app_store_creds = data_bag_item('credentials', 'apple_id')
configurator_app_id = '1037126344'
mas_base_command    = '/usr/local/bin/mas'.freeze

include_recipe 'homebrew'
package 'mas'

execute 'Signin to App Store' do
  command "#{mas_base_command} signin #{app_store_creds[:apple_id]} #{app_store_creds[:password]}"
  sensitive true
  not_if "#{mas_base_command} account"
end

execute 'Install Configurator' do
  command "#{mas_base_command} install #{configurator_app_id}"
end

link '/usr/local/bin/cfgutil' do
  to '/Applications/Apple Configurator 2.app/Contents/MacOS/cfgutil'
end
