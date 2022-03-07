include Chef::Mixin::ShellOut
include MacOS

module MacOS
  class DeveloperAccount
    attr_reader :credentials

    def initialize(apple_id_hash, download_url)
      if download_url.empty?
        @credentials = {
          XCODE_INSTALL_USER: apple_id_hash[:username],
          XCODE_INSTALL_PASSWORD: apple_id_hash[:password],
        }
        authenticate_with_apple(@credentials)
      end
    end

    def authenticate_with_apple(credentials)
      shell_out!(XCVersion.update, env: credentials)
    end
  end
end

Chef::DSL::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
