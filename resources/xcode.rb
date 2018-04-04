resource_name :xcode
default_action %i(setup install_xcode install_simulators)

property :version, String, name_property: true
property :path, String, default: '/Applications/Xcode.app'
property :ios_simulators, Array

action :setup do
  execute 'install Command Line Tools' do
    command lazy { ['softwareupdate', '--install', CommandLineTools.new.product] }
    notifies :create, 'file[sentinel to request on-demand install]', :before
    not_if { ::File.exist?('/Library/Developer/CommandLineTools/usr/lib/libxcrun.dylib') }
    live_stream true
  end

  file 'sentinel to request on-demand install' do
    path '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
    subscribes :delete, 'execute[install Command Line Tools]', :immediately
    action :nothing
  end

  chef_gem 'xcode-install' do
    options('--no-document --no-user-install')
  end
end

action :install_xcode do
  xcode = Xcode.new(new_resource.version,
    -> { data_bag_item(:credentials, :apple_id) },
    node['macos']['apple_id'])

  execute "install Xcode #{xcode.version}" do
    command XCVersion.install_xcode(xcode)
    environment xcode.credentials
    not_if { xcode.installed? }
    timeout 7200
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
