resource_name :startosinstall

property :upgrade_os, [true, false], default: false, required: false
property :package, String, required: false
property :image_index, Integer, default: 3, required: false
property :erase_install, [true, false], default: false

action_class do
  def sparseimage
    ::File.join users_shared, '*.sparseimage'
  end

  def sparseimage_mount_root
    Hdiutil.device_node sparseimage
  end

  def base_system_mount_root
    # Hdiutil.device_node base_system_dmg
    ::File.join '/', 'Volumes', 'OS X Base System'
  end

  def base_system_dmg
    ::File.join '/', 'Volumes', 'Recovery', '*', 'BaseSystem.dmg'
  end

  def users_shared
    ::File.join '/', 'Users', 'Shared'
  end

  def script_source
    url = 'https://raw.githubusercontent.com/munki/macadmin-scripts/master'
    ::File.join url, install_macos_script
  end

  def install_macos_script
    'installinstallmacos.py'
  end

  def script_destination
    ::File.join users_shared, install_macos_script
  end

  def package_destination
    ::File.join users_shared, 'BaseBoxAutomator.pkg'
  end
end

action :install do
  if new_resource.upgrade_os
    file script_destination do
      action :delete
    end

    remote_file script_destination do
      source script_source
      owner node['macos']['admin_user']
      group 'staff'
      mode '0755'
    end

    execute 'download Install macOS' do
      command ['echo', new_resource.image_index.to_s, '|', script_destination, '--workdir', users_shared, '--raw']
      live_stream true
      action :run
    end

    execute 'attach installer' do
      command Hdiutil.attach sparse_image
      live_stream true
    end
  else
    execute 'mount recovery partition' do
      command Diskutil.mount 'Recovery'
      not_if 'mount | grep Recovery'
      live_stream true
      action :run
    end

    execute 'attach BaseSystem.dmg' do
      command Hdiutil.attach base_system_dmg
      not_if 'mount | grep "OS X Base System"'
      live_stream true
      action :run
    end

    remote_file package_destination do
      source new_resource.package
      owner node['macos']['admin_user']
      group 'staff'
      mode '0755'
    end

    execute 'startosinstall' do
      args = new_resource.property_is_set?(:package) ? ['--installpackage', package_destination] : ''
      args << '--eraseinstall' if new_resource.erase_install
      parent_dir = new_resource.upgrade_os ? sparseimage_mount_root : base_system_mount_root
      startosinstall_command = shell_out('find', parent_dir, '-name', 'startosinstall').stdout.chomp
      command [startosinstall_command, '--agreetolicense', *args]
      live_stream true
    end
  end
end
