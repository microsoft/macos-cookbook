include Chef::Mixin::ShellOut
include MacOS

module MacOS
  class DeveloperAccount
    attr_reader :credentials

    def initialize(data_bag_retrieval = nil, node_credential_attributes = nil)
      developer_id = find_apple_id(data_bag_retrieval, node_credential_attributes)
      @credentials = { XCODE_INSTALL_USER:     developer_id['apple_id'],
                       XCODE_INSTALL_PASSWORD: developer_id['password'] }
      authenticate_with_apple(@credentials)
    end

    def authenticate_with_apple(credentials)
      shell_out!(XCVersion.update, env: credentials)
    end

    def find_apple_id(data_bag_retrieval, node_credential_attributes)
      if node_credential_attributes
        { 'apple_id' => node_credential_attributes['user'],
          'password' => node_credential_attributes['password'] }
      else
        data_bag_retrieval.call
      end
    rescue Net::HTTPServerException
      Chef::Application.fatal!('No developer credentials supplied!')
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
