module Xcode
  module Helper
    BASE_COMMAND = '/usr/local/bin/xcversion'.freeze

    def xcode_already_installed?(version)
      xcversion_output = shell_out!("#{BASE_COMMAND} installed").stdout.split
      installed_xcodes = xcversion_output.values_at(*xcversion_output.each_index.select(&:even?))
      installed_xcodes.include?(version)
    end

    def simulator_already_installed?(version)
      available_simulator_versions.include?("#{version} Simulator (installed)")
    end

    def highest_semantic_simulator_version(major_version, simulators)
      requirement = Gem::Dependency.new('iOS', "~> #{major_version}")
      highest = simulators.select { |name, vers| requirement.match?(name, vers) }.highest
      if highest.nil?
        Chef::Application.fatal!("iOS #{major_version} Simulator no longer available from Apple!")
      else
        highest.join(' ')
      end
    end

    def included_simulator_major_version
      version_matcher    = /\d{1,2}\.\d{0,2}\.?\d{0,3}/
      sdks               = shell_out!('/usr/bin/xcodebuild -showsdks').stdout
      included_simulator = sdks.match(/Simulator - iOS (?<version>#{version_matcher})/)
      included_simulator[:version].split('.').first.to_i
    end

    def simulator_list
      available_simulator_versions.split(/\n/).map { |version| version.split[0...2] }
    end

    def available_simulator_versions
      shell_out!("#{BASE_COMMAND} simulators").stdout
    end
  end
end
