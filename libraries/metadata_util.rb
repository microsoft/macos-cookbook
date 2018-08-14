include Chef::Mixin::ShellOut

module MacOS
  class MetadataUtil
    attr_reader :status_flags

    def initialize(volume)
      mdutil_possible_states = { 'Indexing enabled.' => ['on', ''],
                                 'Indexing disabled.' => ['off', ''],
                                 'Indexing and searching disabled.' => ['off', '-d'],
                                 'Spotlight server is disabled.' => %w(dis dis) }

      @status_flags = mdutil_possible_states[volume_current_state(volume)]
                      .insert(1, volume)
    end

    def mdutil_output(volume)
      shell_out('/usr/bin/mdutil', '-s', volume).stdout
    end

    def server_disabled?(volume)
      status_flags == ['dis', volume, 'dis']
    end

    def toggle_spotlight_server(flag)
      action = flag ? 'load' : 'unload'
      ['sudo', 'launchctl', action, '-w', '/System/Library/LaunchDaemons/com.apple.metadata.mds.plist']
    end

    def volume_current_state(volume)
      output = mdutil_output(volume)
      (output.include? ':') ? mdutil_output(volume).split(':')[1].strip : output.strip
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
