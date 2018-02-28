module MacOS
  module Plutil
    def convert_to_hash(path)
      temp_file = ::Tempfile.new.path
      ::FileUtils.copy(path, temp_file)
      shell_out!(plutil_executable, '-convert', 'xml1', temp_file)
      ::Plist.parse_xml(temp_file)
    end

    def plutil_executable
      '/usr/bin/plutil'
    end
  end
end

Chef::Recipe.include(MacOS::Plutil)
Chef::Resource.include(MacOS::Plutil)
