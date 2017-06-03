resource_name :plist

property :user_domain, String, name_property: true
property :preference, String, required: true

default_action :enable

action :enable do
  execute 'set preference' do
    user node['admin_user']
    command "/usr/bin/defaults write #{user_domain} #{preference} TRUE"
  end

  if user_domain == 'com.apple.finder'
    execute 'restart Finder' do
      user node['admin_user']
      command 'killall Finder'
    end
  end
end

action :disable do
  execute 'set preference' do
    user node['admin_user']
    command "/usr/bin/defaults write #{user_domain} #{preference} FALSE"
  end
end