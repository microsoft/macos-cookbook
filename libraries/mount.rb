module Automation
  class Share
    class << self
      def mounted?(mount_point)
        mount_command = shell_out '/sbin/mount'
        mount_command.stdout.match? /#{mount_point}/
      end
    end
  end
end
