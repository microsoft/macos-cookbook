resource_name :macos_mount

property :file_system_type, String, equal_to: ['nfs', 'smb']
property :share_name, String, name_property: true
property :mount_point, String
property :remote_server, String
property :authorized_user
property :options, Array

load_current_value
  value_does_not_exist! unless share_mounted? mount_point

end

action :mount do
  converge_if_changed :mount_point do
    directory new_resource.mount_point do
      mode '0755'
      owner new_resource.authorized_user
      group staff_group
      path 
      action :create
    end
  end

    # NFS
    execute ['/sbin/mount', '-t', 'nfs', mount_url, mount_point] do
      user test_user
      mount_url = "#{source_code_server}:/#{source_code_share}"
      action :nothing
    end

    # SMB
    execute ['/sbin/mount', *options, '-t', 'smbfs', encoded_mount_url, mount_point] do
      notifies :create, 'directory[create mount point]', :before
      action :nothing
    end

    directory mount_point do
      action :nothing
    end
  end
end

action :unmount do
  execute ['/sbin/umount', new_resource.mount_point] do
    only_if { Share.mounted? new_resource.mount_point }
    action :run
    retry_delay 2
    retries 3
  end
end

action_class do
  def options
    '-o', 'nobrowse'
  end

  def encoded_mount_url
    URI.encode "//#{username}:#{password}@#{remote_server}/#{remote_share}"
  end
end
