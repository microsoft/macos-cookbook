include Chef::Mixin::ShellOut
include MacOS

module MacOS
  class DeveloperAccount
    attr_reader :credentials

    def initialize(data_bag_retrieval, node_credential_attributes, download_url)
      if download_url.empty?
        developer_id = find_apple_id(data_bag_retrieval, node_credential_attributes)
        @credentials = {
          XCODE_INSTALL_USER: developer_id['apple_id'],
          XCODE_INSTALL_PASSWORD: developer_id['password'],
        }
        authenticate_with_apple(@credentials)
      end
    end

    def authenticate_with_apple(credentials)
      shell_out!(XCVersion.update, env: credentials)
    end

    def find_apple_id(data_bag_retrieval, node_credential_attributes)
      if node_credential_attributes
        {
          'apple_id' => node_credential_attributes['user'],
          'password' => node_credential_attributes['password'],
        }
      else
        data_bag_retrieval.call
      end
    rescue Net::HTTPServerException
      raise('Developer credentials not supplied, and a URL was not provided for Xcode!')
    end
  end
end

Chef::DSL::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
