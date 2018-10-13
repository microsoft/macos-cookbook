module MacOS
  class Diskutil
    class << self
      def mount(volume_name, read_only: false)
        # disk_id = DiskIdentifier|DeviceNode
        ro = read_only ? 'readOnly' : ''
        [base_command, 'mount', ro, volume_name].join ' '
      end

      def unmount(disk_id, force: false)
        # disk_id = MountPoint|DiskIdentifier|DeviceNode
        force = force ? 'force' : ''
        [base_command, 'unmount', force, disk_id].join ' '
      end

      def base_command
        File.join '/', 'usr', 'sbin', 'diskutil'
      end
    end
  end
end
