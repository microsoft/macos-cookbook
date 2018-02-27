module MacOS
  module PlistAssistant
    def to_hash(path)
      temp_file = ::Tempfile.new.path
      ::FileUtils.copy(path, temp_file)
      shell_out!(plutil_executable, '-convert', 'xml1', temp_file)
      ::Plist.parse_xml(temp)
    end

    def defaults_executable
      '/usr/bin/defaults'
    end

    def plutil_executable
      '/usr/bin/plutil'
    end
  end
end

Chef::Recipe.include(MacOS::PlistAssistant)
Chef::Resource.include(MacOS::PlistAssistant)
