module MacOS
  module MachineName
    def conform_to_dns_standards(hostname)
      hostname.tr(' _', '-')
              .tr(special_chars, '')
              .strip_chars('-_' + special_chars)[0, 63]
    end

    def get_name(name_type)
      valid_names = %w(LocalHostName HostName ComputerName)
      Chef::Application.fatal! "Name type must be one of #{valid_names}. We got '#{name_type}'." unless valid_names.include? name_type
      command = shell_out scutil, '--get', name_type
      command.stdout.chomp
    end

    def current_hostname
      split_hostname.first
    end

    def current_dns_domain
      dns_domain = split_hostname.length - 1
      split_hostname.last(dns_domain).join '.'
    end

    private

    def split_hostname
      hostname = get_name 'HostName'
      hostname.split '.'
    end

    def special_chars
      '!\"\#$%&\'()*+,./:;<=>?'
    end

    def scutil
      '/usr/sbin/scutil'
    end
  end
end

module CharStripper
  def strip_chars(chars)
    chars = Regexp.escape(chars)
    gsub(/^[#{chars}]+|[#{chars}]+$/, '')
  end
end

String.include CharStripper

Chef::Recipe.include MacOS::MachineName
Chef::Resource.include MacOS::MachineName
Chef::DSL::Recipe.include MacOS::MachineName
