unified_mode true

provides :remote_management
default_action :enable

property :users,
         [String, Array],
         default: 'all',
         description: 'The user(s) whose ARD privileges will be configured.',
         coerce: ->(p) { [p].flatten }

property :privileges,
         [String, Array, Integer],
         default: 'all',
         description: 'The desired privileges to bestow upon the given users.',
         coerce: ->(p) { p.is_a?(Integer) ? p : RemoteManagement::BitMask.mask_from_privileges(p) },
         callbacks: { 'is invalid. See https://ss64.com/osx/kickstart.html for valid privileges' => ->(p) { RemoteManagement::BitMask.valid_mask?(p) } }

property :computer_info,
         [String, Array],
         default: [],
         description: 'Info fields; helpful for stratifying computers in ARD client app.',
         coerce: ->(p) { p.compact.map(&:to_s) },
         callbacks: { 'has too many elements; computer info excepts up to four info fields' => ->(p) { (p.is_a?(Array) && p.size < 4) } }

load_current_value do |desired|
  current_value_does_not_exist! unless RemoteManagement.activated? && RemoteManagement.users_configured?(desired.users) && RemoteManagement.users_have_identical_masks?(desired.users)
  privileges RemoteManagement.current_mask(desired.users)
  computer_info RemoteManagement.current_computer_info
end

# TODO; the enable action should be decoupled from configuration; configure action should be added; default action should be [:configure, :enable]

action :enable do
  converge_if_changed(:privileges, :computer_info) do
    raise(RemoteManagement::Exceptions::TCCError) unless RemoteManagement::TCC::DB.correct_privileges?

    execute 'restart the TCC daemon' do
      command 'sudo pkill -9 tccd'
      only_if { platform_version >= Chef::Version.new('12.0.0') }
      not_if { RemoteManagement::TCC::State.enabled? }
    end

    converge_if_changed(:privileges) do
      if new_resource.users.include?('all')
        converge_by('setting privileges for all users') do
          execute 'set privileges for all users' do
            command [RemoteManagement.kickstart, '-configure', '-allowAccessFor', '-allUsers', '-access', '-on', '-privs', '-mask', new_resource.privileges]
          end
        end
      else
        converge_by('setting privileges for specified users') do
          execute 'set up Remote Management to only grant access to users with privileges' do
            command [RemoteManagement.kickstart, '-configure', '-allowAccessFor', '-specifiedUsers']
          end

          execute "set privileges for #{new_resource.users.join(', ')}" do
            command [RemoteManagement.kickstart, '-configure', '-access', '-on', '-privs', '-mask', new_resource.privileges, '-users', new_resource.users.join(',')]
          end
        end
      end
    end

    converge_if_changed(:computer_info) do
      new_resource.computer_info.each_with_index do |info, i|
        execute "set computer info field #{i + 1}" do
          command [RemoteManagement.kickstart, '-configure', '-computerinfo', "-set#{i + 1}", "-#{i + 1}", info]
        end
      end
    end

    execute 'activate the Remote Management service and restart the agent' do
      command [RemoteManagement.kickstart, '-activate', '-restart', '-agent']
    end
  end
end

action :disable do
  execute 'stop the Remote Management service and deactivate it so it will not start after the next restart' do
    command [RemoteManagement.kickstart, '-deactivate', '-stop']
    only_if { RemoteManagement.activated? }
  end
end
