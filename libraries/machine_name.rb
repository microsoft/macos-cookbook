module MacOS
  module MachineName
    def conform_to_rfc1034(name)
      name = String.new name
      name.tr('_', '-').tr('.', '')[0, 63]
    end

    def get_name(name_type)
      valid_names = %w(LocalHostName HostName ComputerName)
      Chef::Application.fatal! "name_type must be one of #{names}" unless valid_names.include? valid_names
      command = shell_out scutil, '--get', name_type
      command.stdout.chomp
    end

    def current_hostname
      split_hostname.first
    end

    def current_domainname
      domainname = split_hostname.length - 1
      split_hostname.last(domainname).join '.'
    end

    def split_hostname(hostname = nil)
      hostname ||= get_name 'HostName'
      hostname.split '.'
    end

    private

    def scutil
      '/usr/sbin/scutil'
    end
  end
end

Chef::Recipe.include(MacOS::MachineName)
Chef::Resource.include(MacOS::MachineName)
Chef::DSL::Recipe.include(MacOS::MachineName)
