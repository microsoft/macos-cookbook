unified_mode true

provides :command_line_tools

property :name, String, default: ''
property :compile_time, [true, false],
  description: 'Install the Xcode Command Line Tools at compile time.',
  default: false, desired_state: false

action :install do
  file 'create demand file' do
    path '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
    group 'wheel'
  end

  command_line_tools = CommandLineTools.new

  execute "install #{command_line_tools.version}" do
    command ['softwareupdate', '--install', command_line_tools.version]
    not_if { ::File.exist?('/Library/Developer/CommandLineTools/usr/lib/libxcrun.dylib') }
    live_stream true
  end

  file 'delete demand file' do
    path '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
    action :delete
  end
end

action :upgrade do
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
