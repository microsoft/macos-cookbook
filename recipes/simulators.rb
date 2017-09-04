n = node['macos']['simulator']['to_install']

ruby_block('set node simulator attributes') {
  block do
    def available_versions
      shell_out!('/usr/local/bin/xcversion simulators').stdout
    end

    def simulator_list
      available_versions.split(/\n/).map { |version| version.split[0...2] }
    end

    def get_major_simulator_version
      version_matcher    = /\d{1,2}\.\d{0,2}\.?\d{0,3}/
      show_sdks_output   = shell_out!('/usr/bin/xcodebuild -showsdks').stdout
      included_simulator = show_sdks_output.match(/Simulator - iOS (?<version>#{version_matcher})/)
      included_simulator[:version]
    end

    def highest_eligible_simulator(simulators, sim_version)
      simulator_requirement = Gem::Dependency.new('iOS', "~> #{sim_version}")
      simulators.select { |name, version| simulator_requirement.match?(name, version) }
          .max.join(' ')
    end

    major_version_to_install = get_major_simulator_version.to_i - n.to_i

    highest_eligible = highest_eligible_simulator(simulator_list, major_version_to_install)

    node.default['macos']['simulator']['to_install']        = highest_eligible
    node.default['macos']['simulator']['already_installed'] =
        available_versions.include?("#{highest_eligible} Simulator (installed)")
  end
}

simulators = '/usr/local/bin/xcversion simulators'

execute 'Install additional iOS simulator' do
  command(lazy { "#{simulators} --install='#{n}'" })
  not_if { node['macos']['simulator']['already_installed'] }
end
