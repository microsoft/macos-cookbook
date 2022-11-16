unified_mode true

provides :xcode
default_action [:install_gem, :install_xcode, :install_simulators]

property :version, String, name_property: true
property :path, String, default: '/Applications/Xcode.app'
property :ios_simulators, Array
property :download_url, String, default: ''
property :apple_id, Hash

action_class do
  def with_appleid_credentials(credentials)
    begin
      ENV['XCODE_INSTALL_USER'] = credentials[:XCODE_INSTALL_USER]
      ENV['XCODE_INSTALL_PASSWORD'] = credentials[:XCODE_INSTALL_PASSWORD]
      yield
    ensure
      ENV['XCODE_INSTALL_USER'] = ''
      ENV['XCODE_INSTALL_PASSWORD'] = ''
    end
  end
end

action :install_gem do
  command_line_tools 'latest'

  execute 'install xcode gem' do
    cwd '/tmp'
    command <<~BASH
          curl -sL -O https://github.com/neonichu/ruby-domain_name/releases/download/v0.5.99999999/domain_name-0.5.99999999.gem && \
          /opt/chef/embedded/bin/gem install --no-document domain_name-0.5.99999999.gem && \
          /opt/chef/embedded/bin/gem install --no-document --conservative xcode-install && \
          rm -f domain_name-0.5.99999999.gem
          BASH
    not_if { ::File.exist? '/opt/chef/embedded/bin/xcversion' }
  end
end

action :install_xcode do
  developer = DeveloperAccount.new(new_resource.apple_id, new_resource.download_url)

  xcode = Xcode.new(
    new_resource.version,
    new_resource.path,
    new_resource.download_url
  )

  if new_resource.download_url.empty?
    with_appleid_credentials(developer.credentials) do
      log 'Log Xcode information' do
        message "Will install Xcode #{xcode.version.call} computed from #{new_resource.version}"
      end
    end
  end

  unless xcode.compatible_with_platform?(node['platform_version'])
    ruby_block 'exception' do
      raise("Xcode #{new_resource.version} not supported on #{node['platform_version']}")
    end
  end

  directory "outdated Xcode bundle at #{new_resource.path}" do
    path new_resource.path
    recursive true
    action :delete
    not_if { xcode.installed? }
  end

  execute "install Xcode #{new_resource.version}" do
    command XCVersion.install_xcode(xcode)
    environment developer.credentials
    cwd '/Users/Shared'
    not_if { xcode.installed? }
    live_stream true
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
