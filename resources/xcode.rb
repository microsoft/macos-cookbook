resource_name :xcode
default_action %i(install_gem install_xcode install_simulators)

property :version, String, name_property: true
property :path, String, default: '/Applications/Xcode.app'
property :ios_simulators, Array

action :install_gem do
  command_line_tools = CommandLineTools.new

  execute "install #{command_line_tools.version}" do
    command ['softwareupdate', '--install', command_line_tools.version]
    not_if { command_line_tools.installed? }
    live_stream true
  end

  file '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress' do
    action :delete
  end

  chef_gem 'xcode-install' do
    options('--no-document --no-user-install')
  end
end

action :install_xcode do
  developer = DeveloperAccount.new(-> { data_bag_item(:credentials, :apple_id) },
                                    node['macos']['apple_id'])

  xcode = Xcode.new(new_resource.version, new_resource.path)

  execute "install Xcode #{xcode.version}" do
    command XCVersion.install_xcode(xcode)
    environment developer.credentials
    not_if { xcode.installed? }
    timeout 7200
  end

  link 'delete symlink created by xcversion gem' do
    target_file '/Applications/Xcode.app'
    action :delete
    only_if 'test -L /Applications/Xcode.app'
  end

  execute "move #{xcode.current_path} to #{new_resource.path}" do
    command ['mv', xcode.current_path, xcode.intended_path]
    not_if { xcode.current_path == xcode.intended_path }
  end

  execute "switch active Xcode to #{new_resource.path}" do
    command ['xcode-select', '--switch', new_resource.path]
  end
end

action :install_simulators do
  if new_resource.ios_simulators
    new_resource.ios_simulators.each do |major_version|
      simulator = Xcode::Simulator.new(major_version)
      next if simulator.included_with_xcode?

      execute "install #{simulator.version} Simulator" do
        command XCVersion.install_simulator(simulator)
        not_if { simulator.installed? }
      end
    end
  end
end
