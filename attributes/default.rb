default['macos']['admin_user'] = 'vagrant'
default['macos']['admin_password'] = 'vagrant'

default['macos']['mono']['package'] = 'MonoFramework-MDK-4.4.2.11.macos10.xamarin.universal.pkg'
default['macos']['mono']['version'] = '4.4.2'
default['macos']['mono']['checksum'] = 'd8bfbee7ae4d0d1facaf0ddfb70c0de4b1a3d94bb1b4c38e8fa4884539f54e23'

default['macos']['xcode']['version'] = '9.2'
default['macos']['xcode']['simulator']['major_version'] = %w(11 10)

default['macos']['remote_login_enabled'] = true
default['macos']['disk_sleep_disabled'] = false

default['macos']['network_time_server'] = 'time.apple.com'
default['macos']['time_zone'] = 'America/Los_Angeles'

node.default['authorization']['sudo']['groups'] = 'wheel'
node.default['authorization']['sudo']['users'] = ['root', node['macos']['admin_user']]
node.default['authorization']['sudo']['passwordless'] = true
node.default['authorization']['sudo']['include_sudoers_d'] = true
node.default['authorization']['sudo']['agent_forwarding'] = true
node.default['authorization']['sudo']['setenv'] = true
node.default['authorization']['sudo']['sudoers_defaults'] = [
  'env_reset',
  'env_keep += "BLOCKSIZE"',
  'env_keep += "COLORFGBG COLORTERM"',
  'env_keep += "__CF_USER_TEXT_ENCODING"',
  'env_keep += "CHARSET LANG LANGUAGE LC_ALL LC_COLLATE LC_CTYPE"',
  'env_keep += "LC_MESSAGES LC_MONETARY LC_NUMERIC LC_TIME"',
  'env_keep += "LINES COLUMNS"',
  'env_keep += "LSCOLORS"',
  'env_keep += "TZ"',
  'env_keep += "DISPLAY XAUTHORIZATION XAUTHORITY"',
  'env_keep += "EDITOR VISUAL"',
  'env_keep += "HOME MAIL"',
  'lecture_file = "/etc/sudo_lecture"',
]
