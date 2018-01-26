resource_name :spotlight
default_action %i(set)

property :volume, String, name_property: true
property :indexed, [true, false], default: true
property :erase_store, [true, false], default: false
property :allow_search, [true, false], default: true

action_class do
  def erase_store?
    new_resource.erase_store ? '-E' : ''
  end

  def allow_search?
    new_resource.allow_search ? '' : '-d'
  end

  def state
    new_resource.indexed ? 'on' : 'off'
  end

  def volume_path(volume)
    if volume == '/'
      volume
    else
      "/Volumes/#{volume}"
    end
  end

  def mdutil
    '/usr/bin/mdutil'
  end
end

action :set do
  execute "turn Spotlight indexing #{state} for #{new_resource.volume}" do
    command [mdutil, erase_store?, '-i', state, volume_path(new_resource.volume), allow_search?]
  end
end
