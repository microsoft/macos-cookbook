resource_name :spotlight
default_action :set

property :volume, String, name_property: true
property :indexed, [true, false], default: true
property :searchable, [true, false], default: true

action_class do
  def state
    new_resource.indexed ? 'on' : 'off'
  end

  def search
    new_resource.searchable ? '' : '-d'
  end

  def volume_path(volume)
    volume == '/' ? volume : ::File.join('/Volumes', volume)
  end

  def target_volume
    volume_path(new_resource.volume)
  end

  def mdutil
    ['/usr/bin/mdutil']
  end

  def desired_spotlight_state
    [state, target_volume, search]
  end
end

action :set do
  macosx_service 'metadata server' do
    service_name 'com.apple.metadata.mds'
    plist '/System/Library/LaunchDaemons/com.apple.metadata.mds.plist'
    action [:enable, :start]
  end

  execute "turn Spotlight indexing #{state} for #{target_volume}" do
    command mdutil + desired_spotlight_state.insert(0, '-i')
    not_if { MetadataUtil.new(target_volume).status_flags == desired_spotlight_state }
  end
end
