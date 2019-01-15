resource_name :command_line_tools

property :compile_time, [TrueClass, FalseClass],
  description: "Install the Xcode Command Line Tools at compile time.",
  default: false, desired_state: false

action_class do
  def installed?
    ::File.exist?('/Library/Developer/CommandLineTools/usr/lib/libxcrun.dylib')
  end
end

action :install do
  unless installed?
    command_line_tools = CommandLineTools.new
    
    execute "install #{command_line_tools.version}" do
      command ['softwareupdate', '--install', command_line_tools.version]
      not_if { installed? }
      live_stream true
    end
    
    file '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress' do
      action :delete
    end
  end
end

def after_created
  return unless compile_time
  Array(action).each do |action|
    run_action(action)
  end
end
