resource_name :spotlight
default_action :set

property :directory, String, name_property: true
property :indexing, [:enabled, :disabled], default: :enabled
property :searchable, [true, false], default: true

action_class do
  def state
    new_resource.indexing == :enabled ? 'on' : 'off'
  end

  def search
    new_resource.searchable ? '' : '-d'
  end

  def mdutil
    ['/usr/bin/mdutil']
  end

  def mdutil_status
    shell_out(mdutil, '-s', new_resource.directory).stdout
  end

  def index_status
    mdutil_status.split(':')[1]
  end

  def desired_spotlight_state
    [state, new_resource.directory, search]
  end
end

load_current_value do
  indexing shell_out('/usr/bin/mdutil', '-s', directory).stdout.split(':')[1].split(' ')[1]
end

action :set do
  macosx_service 'spotlight server' do
    service_name 'mds'
    plist '/System/Library/LaunchDaemons/com.apple.metadata.mds.plist'
    action [:enable, :start]
  end

  converge_if_changed :indexing do
    execute "Spotlight indexing is #{state}" do
      command mdutil + desired_spotlight_state.insert(0, '-i')
    end
  end
end
