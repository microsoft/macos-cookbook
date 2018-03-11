require 'pry'

module MacOS
  module MachineName
    def conform_to_rfc1034(hostname)
      hostname.tr(' _', '-')
              .tr(special_chars, '')
              .strip_chars('-_' + special_chars)[0, 63]
    end

    def get_name(name_type)
      valid_names = %w(LocalHostName HostName ComputerName)
      Chef::Application.fatal! "name_type must be one of #{valid_names}" unless valid_names.include? valid_names
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

    def split_hostname(hostname = nil)
      hostname ||= get_name 'HostName'
      hostname.split '.'
    end

    private

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
