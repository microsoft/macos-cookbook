unified_mode true

provides :command_line_tools

property :name, String, default: ''
property :beta, [true, false], default: false
property :compile_time, [true, false],
  description: 'Install the Xcode Command Line Tools at compile time.',
  default: false, desired_state: false

action :install do
  if new_resource.beta
    file 'create CLT folder' do
      path '/Library/Developer/CommandLineTools'
      recursive true
    end

    file 'create beta demand file' do
      path '/Library/Developer/CommandLineTools/.beta'
    end
  end

  file 'create demand file' do
    path '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
    group 'wheel'
    not_if { ::File.exist?('/Library/Developer/CommandLineTools/usr/lib/libxcrun.dylib') }
    notifies :run, 'execute[install command line tools]', :immediately
  end

  command_line_tools = CommandLineTools.new

  execute 'install command line tools' do
    command ['softwareupdate', '--install', command_line_tools.version]
    live_stream true
    action :nothing
  end

  file 'delete demand file' do
    path '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
    action :delete
  end
end

action :upgrade do
  if new_resource.beta
    file 'create CLT folder' do
      path '/Library/Developer/CommandLineTools'
      recursive true
    end

    file 'create beta demand file' do
      path '/Library/Developer/CommandLineTools/.beta'
    end
  end

  file 'create demand file' do
    path '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
    group 'wheel'
  end

  command_line_tools = CommandLineTools.new

  execute "upgrade #{command_line_tools.version}" do
    command ['softwareupdate', '--install', command_line_tools.latest_from_catalog]
    not_if { command_line_tools.version == command_line_tools.latest_from_catalog }
    live_stream true
  end

  file 'delete demand file' do
    path '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
    action :delete
  end
end

def after_created
  return unless compile_time
  Array(action).each do |action|
    run_action(action)
  end
end
