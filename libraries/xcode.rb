module Xcode
  module Helper
    BASE_COMMAND = '/usr/local/bin/xcversion'.freeze

    def xcode_already_installed?(version)
      xcversion_output = shell_out!("#{BASE_COMMAND} installed").stdout.split
      installed_xcodes = xcversion_output.values_at(*xcversion_output.each_index.select(&:even?))
      installed_xcodes.include?(version)
    end

    def highest_eligible_simulator(simulators, major_version)
      simulator_requirement = Gem::Dependency.new('iOS', "~> #{major_version}")
      simulators.select { |name, version| simulator_requirement.match?(name, version) }.max
    end

    def included_major_simulator_version
      version_matcher    = /\d{1,2}\.\d{0,2}\.?\d{0,3}/
      sdks               = shell_out!('/usr/bin/xcodebuild -showsdks').stdout
      included_simulator = sdks.match(/Simulator - iOS (?<version>#{version_matcher})/)
      included_simulator[:version].split('.').first
    end

    def simulator_list
      available_simulator_versions.split(/\n/).map { |version| version.split[0...2] }
    end

    def available_simulator_versions
      shell_out!("#{BASE_COMMAND} simulators").stdout
    end
  end
end
