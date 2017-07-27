resource_name :ard

BASE_COMMAND = '/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart'.freeze

property :status, String, name_property: true
property :settings, Hash
property :privileges, Hash

sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart
-activate -configure -allowAccessFor -allUsers -privs -all -clientopts -setmenuextra -menuextra yes



ard 'activate'
ard 'restart'
