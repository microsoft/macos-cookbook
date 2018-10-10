module MacOS
  class Diskutil
    class << self
      def mount(disk_id, mount_path: '/Volumes', read_only: false)
        # disk_id = DiskIdentifier|DeviceNode
        ro = read_only ? 'readOnly' : ''
        mp = "-mountPath #{mount_path}"
        [base_command, 'mount', ro, mp, disk_id].join ' '
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
