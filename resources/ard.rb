resource_name :ard

BASE_COMMAND = '/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart'.freeze

property :status, String, name_property: true
property :options, Hash
property :privileges, Hash

action :run do
  case new_resource.status
  when 'activate'
    execute BASE_COMMAND do
      command "#{BASE_COMMAND} #{new_resource.status}"
    end

  when 'deactivate'
    execute BASE_COMMAND do
      command "#{BASE_COMMAND} #{new_resource.status}"
    end

  when 'restart'
    execute BASE_COMMAND do
      command "#{BASE_COMMAND} #{new_resource.status}"
    end

  else
    execute BASE_COMMAND do
      command "#{BASE_COMMAND}"

    end

sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart
-activate -configure -allowAccessFor -allUsers -privs -all -clientopts -setmenuextra -menuextra yes

# if not activate, deactivate, or restart, move to -configure

ard 'activate'
ard 'restart'
