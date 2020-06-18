provides :pmset
default_action :run

BASE_COMMAND = '/usr/bin/pmset'.freeze

property :settings, Hash

action :run do
  new_resource.settings.each do |setting, value|
    execute BASE_COMMAND do
      command "#{BASE_COMMAND} #{setting} #{value}"
    end
  end
end

# womp - wake on ethernet magic packet (value = 0/1). Same as "Wake for network
# access" in the Energy Saver preferences.

# ring - wake on modem ring (value = 0/1)

# powernap - enable/disable Power Nap on supported machines (value = 0/1)

# autorestart - automatic restart on power loss (value = 0/1)

# lidwake - wake the machine when the laptop lid (or clamshell) is opened
# (value = 0/1)

# acwake - wake the machine when power source (AC/battery) is changed
# (value = 0/1)

# lessbright - slightly turn down display brightness when switching to this
# power source (value = 0/1)

# halfdim - display sleep will use an intermediate half-brightness state between
# full brightness and fully off  (value = 0/1)

# sms - use Sudden Motion Sensor to park disk heads on sudden changes in G force
# (value = 0/1)

# hibernatemode - change hibernation mode. Please use caution. (value = integer)

# hibernatefile - change hibernation image file location.
# Image may only be located on the root volume. Please use caution.
# (value = path)

# ttyskeepawake - prevent idle system sleep when any tty
# (e.g. remote login session) is 'active'. A tty is 'inactive' only when its
# idle time exceeds the system sleep timer. (value = 0/1)

# networkoversleep - this setting affects how OS X networking presents
# shared network services during system sleep. This setting is not used by all
# platforms; changing its value is unsupported.
#
# destroyfvkeyonstandby - Destroy File Vault Key when going to standby mode.
# By default File vault keys are retained even when system goes to standby.
# If the keys are destroyed, user will be prompted to enter the password
# while coming out of standby mode. (value: 1 - Destroy, 0 - Retain)
