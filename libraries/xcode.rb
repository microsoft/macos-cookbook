include Chef::Mixin::ShellOut

module MacOS
  module Xcode
    class << self
      def installed?(semantic_version)
        xcversion_output = shell_out(XCVersion.installed_xcodes).stdout.split
        installed_xcodes = xcversion_output.values_at(*xcversion_output.each_index.select(&:even?))
        installed_xcodes.include?(semantic_version)
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

      def available_versions
        shell_out!(XCVersion.list_simulators).stdout
      end

      class << self
        def installed?(semantic_version)
          shell_out!(XCVersion.list_simulators)
            .stdout.include?("#{semantic_version} Simulator (installed)")
        end

        def included_major_version
          version_matcher    = /\d{1,2}\.\d{0,2}\.?\d{0,3}/
          sdks               = shell_out!('/usr/bin/xcodebuild -showsdks').stdout
          included_simulator = sdks.match(/Simulator - iOS (?<version>#{version_matcher})/)
          included_simulator[:version].split('.').first.to_i
        end
      end
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
