module MacOS
  module SystemSetup
    def running_in_a_vm?
      Chef.node['hardware']['machine_model'].match?(/Parallels/) # TODO: cover more hypervisors
    end

    def power_button_model?
      Chef.node['hardware']['machine_model'].match? Regexp.union %w(Macmini MacPro)
    end

    def screensaver_disabled?
      screensaver_settings('read', '0') &&
      screensaver_settings('read-type', 'integer')
    end

    private

    def screensaver_settings(query_type, expected_value)
      expression_pattern = Regexp.new(expected_value)
      shell_out('defaults', '-currentHost', query_type, 'com.apple.screensaver', 'idleTime',
        user: Chef.node['macos']['admin_user'])
      .stdout.chomp.match?(expression_pattern)
    end
  end
end

Chef::Recipe.include(MacOS::SystemSetup)
Chef::Resource.include(MacOS::SystemSetup)
Chef::DSL::Recipe.include(MacOS::SystemSetup)
