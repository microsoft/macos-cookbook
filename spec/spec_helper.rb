require 'chefspec'
require 'chefspec/berkshelf'

require_relative '../libraries/macos_user'
require_relative '../libraries/metadata_util'
require_relative '../libraries/plist'
require_relative '../libraries/system'
require_relative '../libraries/xcode'
require_relative '../libraries/xcversion'
require_relative '../libraries/developer_account'
require_relative '../libraries/command_line_tools'
require_relative '../libraries/security_cmd'
require_relative '../libraries/ard'

RSpec.configure do |config|
  config.platform = 'mac_os_x'
  config.version = '10.13'
end
