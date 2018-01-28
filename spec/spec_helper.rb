require 'chefspec'
require 'chefspec/berkshelf'

require_relative '../libraries/macos_user'
require_relative '../libraries/plist'
require_relative '../libraries/xcode'
require_relative '../libraries/xcversion'
require_relative '../libraries/metadata_util'

RSpec.configure do |config|
  config.platform = 'mac_os_x'
  config.version = '10.12'
end
