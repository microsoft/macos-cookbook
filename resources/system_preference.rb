resource_name :system_preference

property :preference, Symbol, required: true, desired_state: false
property :setting, String, required: true, desired_state: true

load_current_value do |desired|
  get_setting = ['-get', desired.preference.to_s].join('')
  command = shell_out('/usr/sbin/systemsetup', get_setting)
  current_setting = command.stdout.split(':').last.strip.split

  if current_setting.include?('after')
    setting current_setting[1]
  else
    setting current_setting.last
  end
end

action :set do
  converge_if_changed do
    converge_by "set #{new_resource.preference} to #{new_resource.setting}" do
      set_pref = ['-set', new_resource.preference.to_s].join('')
      execute ['/usr/sbin/systemsetup', set_pref, new_resource.setting]
      execute ['/usr/sbin/systemsetup', set_pref, new_resource.setting]
      execute ['/usr/sbin/systemsetup', set_pref, new_resource.setting]
    end
  end
end
