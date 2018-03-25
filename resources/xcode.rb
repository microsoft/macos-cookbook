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

  CREDENTIALS_DATA_BAG = data_bag_item(:credentials, :apple_id)

  DEVELOPER_CREDENTIALS = {
    XCODE_INSTALL_USER:     CREDENTIALS_DATA_BAG['apple_id'],
    XCODE_INSTALL_PASSWORD: CREDENTIALS_DATA_BAG['password'],
  }.freeze

  execute 'update available Xcode versions' do
    environment DEVELOPER_CREDENTIALS
    command XCVersion.update
  end
end

action :install_xcode do
  execute "install Xcode #{new_resource.version}" do
    environment DEVELOPER_CREDENTIALS
    command XCVersion.install_xcode(new_resource.version)
    not_if { Xcode.installed?(new_resource.version) }
  end
end

action :install_simulators do
  if new_resource.ios_simulators
    new_resource.ios_simulators.each do |major_version|
      next if major_version.to_i >= Xcode::Simulator.included_major_version
      version = Xcode::Simulator.new(major_version).version

      execute "install latest iOS #{major_version} Simulator" do
        environment DEVELOPER_CREDENTIALS
        command XCVersion.install_simulator(version)
        not_if { Xcode::Simulator.installed?(version) }
      end
    end
  end
end
