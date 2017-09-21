resource_name :xcode
default_action :install

property :version, String, name_property: true
property :path, String, default: '/Applications/Xcode.app'
property :ios_simulators, Array

begin
  require 'xcode-install'
rescue LoadError
  system 'gem install xcode-install --no-ri --no-doc', out: :close
  Gem.clear_paths
end

BASE_COMMAND = '/usr/local/bin/xcversion'.freeze
CREDENTIALS_DATA_BAG = Chef::DataBagItem.load(:credentials, :apple_id)
DEVELOPER_CREDENTIALS = {
  'XCODE_INSTALL_USER' => CREDENTIALS_DATA_BAG['apple_id'],
  'XCODE_INSTALL_PASSWORD' => CREDENTIALS_DATA_BAG['password'],
}.freeze

action :install do
  Chef::Log.warn('Reading currently available versions from Apple')
  execute 'get Xcode versions currently available from Apple' do
    command "#{BASE_COMMAND} update"
    environment DEVELOPER_CREDENTIALS
    not_if { xcode_already_installed?(new_resource.version) }
  end

  Chef::Log.warn("Installing requested Xcode version: #{new_resource.version} at #{new_resource.path}")
  execute 'installed requested Xcode' do
    command "#{BASE_COMMAND} install '#{new_resource.version}'"
    environment DEVELOPER_CREDENTIALS
    creates new_resource.path
    not_if { xcode_already_installed?(new_resource.version) }
  end

  Chef::Log.warn("Installing requested simulator versions: #{new_resource.ios_simulators}")
  new_resource.ios_simulators.each do |simulator|
    next if highest_eligible_sim
    qulator(simulator_list, simulator).nil?
    execute "Install iOS #{simulator} simulator" do
      semantic_version = highest_eligible_simulator(simulator_list, simulator).join(' ')
      command "#{BASE_COMMAND} simulators --install='#{semantic_version}'"
      subscribes :run, execute["#{BASE_COMMAND} install '#{new_resource.version}'"], :immediate
      not_if { available_simulator_versions.include?("#{semantic_version} Simulator (installed)") }
    end
  end

  Chef::Log.warn('Accepting Xcode license')
  execute 'accept Xcode license' do
    command '/usr/bin/xcodebuild -license accept'
  end
end

def xcode_already_installed?(version)
  xcversion_output = shell_out!("#{BASE_COMMAND} installed").stdout.split
  installed_xcodes = xcversion_output.values_at(*xcversion_output.each_index.select(&:even?))
  installed_xcodes.include?(version)
end

def highest_eligible_simulator(simulators, major_version)
  simulator_requirement = Gem::Dependency.new('iOS', "~> #{major_version}")
  simulators.select { |name, version| simulator_requirement.match?(name, version) }.max
end

def included_simulator_version
  version_matcher    = /\d{1,2}\.\d{0,2}\.?\d{0,3}/
  sdks               = shell_out!('/usr/bin/xcodebuild -showsdks').stdout
  included_simulator = sdks.match(/Simulator - iOS (?<version>#{version_matcher})/)
  included_simulator[:version]
end

def simulator_list
  available_simulator_versions.split(/\n/).map { |version| version.split[0...2] }
end

def available_simulator_versions
  shell_out!("#{BASE_COMMAND} simulators").stdout
end
