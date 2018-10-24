module MacOS
  class ARD
    def ard_already_activated?
      ::File.exist?('/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd')
    end
  end
end

Chef::Recipe.include(MacOS::ARD)
Chef::Resource.include(MacOS::ARD)
