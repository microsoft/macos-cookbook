require_relative 'plist'

include MacOS::PlistHelpers

module MacOS
  class PlistBuddy
    attr_reader :path
    attr_reader :entry

    def initialize(entry, path)
      @entry = ':' + Shellwords.shellescape(entry)
      @path = Shellwords.shellescape(path)
    end

    def add(value = nil)
      construct_command __method__.to_s.capitalize, entry_type_to_string(value), value
    end

    def set(value)
      construct_command __method__.to_s.capitalize, value
    end

    def delete
      construct_command __method__.to_s.capitalize
    end

    def print
      construct_command __method__.to_s.capitalize
    end

    private

    def construct_command(action, *components)
      core_command = [action, @entry, components].join(' ').strip
      plistbuddy_wrapper core_command
    end

    def plistbuddy_wrapper(core_command)
      [plistbuddy_executable, '-c', "\'#{core_command}\'", @path]
    end

    def add_container # dict or array logic goes here
    end

    def plistbuddy_executable
      '/usr/libexec/PlistBuddy'
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
