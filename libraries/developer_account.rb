include Chef::Mixin::ShellOut
include MacOS

module MacOS
  class DeveloperAccount
    attr_reader :credentials

    def initialize(apple_id_hash, download_url)
      if download_url.empty?
        developer_id = validate_apple_id(apple_id_hash)
        @credentials = {
          XCODE_INSTALL_USER: developer_id[:username],
          XCODE_INSTALL_PASSWORD: developer_id[:password],
        }
        authenticate_with_apple(@credentials)
      end
    end

    def validate_apple_id(apple_id_hash)
      if apple_id_hash.values.any?
        {
          username: apple_id_hash[:username],
          password: apple_id_hash[:password],
        }
      elsif ENV['XCODE_INSTALL_USER'] && ENV['XCODE_INSTALL_PASSWORD']
        {
          username: ENV['XCODE_INSTALL_USER'],
          password: ENV['XCODE_INSTALL_PASSWORD'],
        }
      else
        raise('Developer credentials not supplied, and a URL was not provided for Xcode!')
      end
    end

    def authenticate_with_apple(credentials)
      shell_out!(XCVersion.update, env: credentials)
    end
  end
end

Chef::DSL::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
