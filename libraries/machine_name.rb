module MacOS
  module MachineName
    def scutil
      '/usr/sbin/scutil'
    end

    def major_os_version
      major_vers_pattern = Regexp.new('(\d+\.\d+)\.\d+')
      Chef.node['platform_version'].split(major_vers_pattern).last
    end

    def conform_to_rfc1034(name)
      name = ::String.new(name)
      name.tr('_.', '')
    end

    def get_name(name_type)
      names = %w(LocalHostName HostName ComputerName)
      Chef::Application.fatal!("name_type must be one of #{names}", error_code) unless names.include?(name_type)
      command = shell_out(scutil, '--get', name_type)
      command.stdout.chomp
    end

    def current_hostname
      split_up.first
    end

    def current_domainname
      without_short = split_up.length - 1
      split_up.last(without_short).join('.')
    end

    private

    def split_up
      get_name('HostName').split('.')
    end
  end
end

Chef::Recipe.include(MacOS::MachineName)
Chef::Resource.include(MacOS::MachineName)
Chef::DSL::Recipe.include(MacOS::MachineName)
