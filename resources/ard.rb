resource_name :ard

BASE_COMMAND = '/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart'.freeze

property :status, String, name_property: true
property :options, Hash
property :privileges, Hash

action :run do
  case new_resource.status
  when 'activate'
    execute BASE_COMMAND do
      command "#{BASE_COMMAND} -#{new_resource.status} -configure -allowAccessFor -allUsers"
    end

  when 'deactivate'
    execute BASE_COMMAND do
      command "#{BASE_COMMAND} -#{new_resource.status} -configure -access -off"
    end

  when 'restart'
    execute BASE_COMMAND do
      command "#{BASE_COMMAND} -#{new_resource.status} -agent"
    end

  else
    execute BASE_COMMAND do
      command "#{BASE_COMMAND} -configure"

    end
  end
end

# activate
# sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart
# -activate -configure -allowAccessFor -allUsers -privs -all -clientopts -setmenuextra -menuextra yes

# deactivate
# sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -configure -access -off

# restart
# sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent
