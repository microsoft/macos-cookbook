module MacOS
  module Defaults
    def hardware_uuid # used with ByHost preferences
      system_profiler_hardware_output = shell_out('system_profiler', 'SPHardwareDataType').stdout
      hardware_overview = Psych.load(system_profiler_hardware_output)['Hardware']['Hardware Overview']
      hardware_overview['Hardware UUID']
    end

    private

    def defaults_executable
      '/usr/bin/defaults'
    end
  end
end

Chef::Recipe.include(MacOS::Defaults)
Chef::Resource.include(MacOS::Defaults)
