resource_name :spotlight
default_action :set

property :directory, String, name_property: true
property :indexing, equal_to: [:enabled, :disabled], default: :enabled
property :search, equal_to: [:enabled, :disabled], default: :enabled
property :volumes, [Array, String]

load_current_value do
  mdutil = '/usr/bin/mdutil'
  indexing_output = shell_out("#{mdutil} -s #{directory}").stdout
  current_status = indexing_output.split(' ').last.delete('.')
  indexing current_status.to_sym
end

action :set do
  macosx_service 'metadata server' do
    service_name 'com.apple.metadata.mds'
    plist '/System/Library/LaunchDaemons/com.apple.metadata.mds.plist'
    action [:enable, :start]
  end

  converge_if_changed :indexing do
    converge_by "set Spotlight indexing to #{state}" do
      execute "#{mdutil} -i #{state} #{new_resource.directory}"
    end
  end
end

action_class do
  def state
    states = { enabled: 'on', disabled: 'off' }
    states[new_resource.indexing]
  end

  def search
    states = { enabled: '', disabled: '-d' }
    states[new_resource.search]
  end

  def mdutil
    '/usr/bin/mdutil'
  end
end
