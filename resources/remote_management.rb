resource_name :remote_management
default_action %i(enable configure)

kickstart = '/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart'

action :enable do
  execute "#{kickstart} -activate" do
    not_if { RemoteManagement.activated? }
  end
end

action :disable do
  execute "#{kickstart} -deactivate" do
    only_if { RemoteManagement.activated? }
  end

  execute "#{kickstart} -stop" do
    only_if { RemoteManagement.activated? }
  end
end

action :configure do
  execute "#{kickstart} -configure -allowAccessFor -allUsers -access -on -privs -all" do
    not_if { RemoteManagement.configured? }
  end
end
