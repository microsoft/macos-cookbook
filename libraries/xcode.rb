include Chef::Mixin::ShellOut

module MacOS
  class Xcode
    attr_reader :version
    attr_reader :credentials

    def initialize(semantic_version, data_bag_retrieval = nil, node_credential_attributes = nil)
      developer_id = find_apple_id(data_bag_retrieval, node_credential_attributes)
      @credentials = { XCODE_INSTALL_USER:     developer_id['apple_id'],
                       XCODE_INSTALL_PASSWORD: developer_id['password'] }
      authenticate_with_apple(@credentials)

      @semantic_version = semantic_version
      apple_version = Xcode::Version.new(@semantic_version).apple_version
      @version = available_versions_list[xcode_index(apple_version)].strip
    end

    def xcode_index(xcode_version)
      available_xcodes.index { |xcode| xcode.apple_version == xcode_version }
    end

    def available_versions_list
      shell_out!(XCVersion.list_xcodes).stdout.lines
    end

    def available_xcodes
      available_versions_list.map { |v| Xcode::Version.new v.split.first }
    end

    def installed?
      xcversion_output = shell_out(XCVersion.installed_xcodes).stdout.split
      xcversion_output.include?(@semantic_version)
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

    class Simulator
      attr_reader :version

      def initialize(major_version)
        while available_list.empty?
          Chef::Log.warn('iOS Simulator list not populated yet')
          sleep 10
        end
        if latest_semantic_version(major_version).nil?
          Chef::Application.fatal!("iOS #{major_version} Simulator no longer available from Apple!")
        else
          @version = latest_semantic_version(major_version).join(' ')
        end
      end

      def latest_semantic_version(major_version)
        requirement = Gem::Dependency.new('iOS', "~> #{major_version}")
        available_list.select { |platform, version| requirement.match?(platform, version) }.max
      end

      def available_list
        available_versions.split(/\n/).map { |version| version.split[0..1] }
      end

      def installed?
        available_versions.include?("#{@version} Simulator (installed)")
      end

      def available_versions
        shell_out!(XCVersion.list_simulators).stdout
      end

      def show_sdks
        shell_out!('/usr/bin/xcodebuild -showsdks').stdout
      end

      def included_with_xcode?
        version_matcher    = /\d{1,2}\.\d{0,2}\.?\d{0,3}/
        included_simulator = show_sdks.match(/Simulator - iOS (?<version>#{version_matcher})/)
        @version.split.last.to_i == included_simulator[:version].to_i
      end
    end

    class Version < Gem::Version
      def major
        _segments.first
      end

      def minor
        _segments[1] || 0
      end

      def patch
        _segments[2] || 0
      end

      def major_release?
        minor == 0 && patch == 0
      end

      def minor_release?
        minor != 0 && patch == 0
      end

      def patch_release?
        patch != 0
      end

      def apple_version
        if major_release?
          major
        else
          version
        end
      end
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
