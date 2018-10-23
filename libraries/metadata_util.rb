include Chef::Mixin::ShellOut

module MacOS
  class MetadataUtil
    attr_reader :status_flags
    attr_reader :mdutil_output

    def initialize(volume)
      mdutil_possible_states = { 'Indexing enabled.' => ['on', ''],
                                 'Indexing disabled.' => ['off', ''],
                                 'Indexing and searching disabled.' => ['off', '-d'],
                                 'Error' => ['', ''] }

      @mdutil_output = shell_out('/usr/bin/mdutil', '-s', volume).stdout
      @status_flags = mdutil_possible_states[volume_current_state(volume)].insert(1, volume)
    end

    def volume_current_state(_volume)
      mdutil_output.split(':')[1].strip
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
