include Xcode::Helper

resource_name :xcode
default_action %i(setup install_xcode install_simulators)

property :version, String, name_property: true
property :path, String, default: '/Applications/Xcode.app'
property :ios_simulators, Array

action :setup do
  gem_package 'xcode-install' do
    options('--no-document')
  end
end

action :install_xcode do
  CREDENTIALS_DATA_BAG = data_bag_item(:credentials, :apple_id)

  DEVELOPER_CREDENTIALS = {
    XCODE_INSTALL_USER:     CREDENTIALS_DATA_BAG['apple_id'],
    XCODE_INSTALL_PASSWORD: CREDENTIALS_DATA_BAG['password'],
  }.freeze

  execute 'update available Xcode versions' do
    environment DEVELOPER_CREDENTIALS
    command "#{BASE_COMMAND} update"
  end

  execute "install Xcode #{new_resource.version}" do
    environment DEVELOPER_CREDENTIALS
    command "#{BASE_COMMAND} install '#{new_resource.version}'"
    creates new_resource.path
    not_if { xcode_already_installed?(new_resource.version) }
  end

  execute "switch Xcode to #{new_resource.path}" do
    command "xcode-select --switch #{new_resource.path}"
  end

  execute 'accept license' do
    command '/usr/bin/xcodebuild -license accept'
  end
end

action :install_simulators do
  if new_resource.ios_simulators
    new_resource.ios_simulators.each do |major_version|
      next if major_version.to_i >= included_simulator_major_version
      version = highest_semantic_simulator_version(major_version, simulator_list)

      execute "install #{version} Simulator" do
        environment DEVELOPER_CREDENTIALS
        command "#{BASE_COMMAND} simulators --install='#{version}'"
        not_if { simulator_already_installed?(version) }
      end
    end
  end
end
