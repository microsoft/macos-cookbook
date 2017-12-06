include Chef::Mixin::ShellOut

module MacOS
  module Xcode
    class << self
      def installed?(semantic_version)
        xcversion_output = shell_out("#{XCVersion.command} installed").stdout.split
        installed_xcodes = xcversion_output.values_at(*xcversion_output.each_index.select(&:even?))
        installed_xcodes.include?(semantic_version)
      end

      def bundle_version_correct?
        xcode_version = '/Applications/Xcode.app/Contents/version.plist CFBundleShortVersionString'
        node['macos']['xcode']['version'] == shell_out("defaults read #{xcode_version}").stdout.strip
      end

      module Simulator
        class << self
          def installed?(semantic_version)
            available_simulator_versions.include?("#{semantic_version} Simulator (installed)")
          end

          def highest_semantic_version(major_version, simulators)
            requirement = Gem::Dependency.new('iOS', "~> #{major_version}")
            highest = simulators.select { |name, vers| requirement.match?(name, vers) }.max
            if highest.nil?
              Chef::Application.fatal!("iOS #{major_version} Simulator no longer available from Apple!")
            else
              highest.join(' ')
            end
          end

          def included_major_version
            version_matcher    = /\d{1,2}\.\d{0,2}\.?\d{0,3}/
            sdks               = shell_out!('/usr/bin/xcodebuild -showsdks').stdout
            included_simulator = sdks.match(/Simulator - iOS (?<version>#{version_matcher})/)
            included_simulator[:version].split('.').first.to_i
          end

          def list
            available_simulator_versions.split(/\n/).map { |version| version.split[0...2] }
          end

          def available_versions
            shell_out!("#{XCVersion.command} simulators").stdout
          end
        end
      end
    end
  end
end

Chef::Recipe.include(MacOS::Xcode)
Chef::Resource.include(MacOS::Xcode)
