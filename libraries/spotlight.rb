include Chef::Mixin::ShellOut

module MacOS
  module MetadataUtil
    class << self
      def status(volume)
        volume_current_state = shell_out("/usr/bin/mdutil -s #{volume.shellescape}")
                               .stdout.split(':')[1].strip

        mdutil_possible_states = { 'Indexing enabled.' => ['on', ''],
                                   'Indexing disabled.' => ['off', ''],
                                   'Indexing and searching disabled.' => ['off', '-d'] }

        mdutil_possible_states[volume_current_state].insert(1, volume)
      end
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
