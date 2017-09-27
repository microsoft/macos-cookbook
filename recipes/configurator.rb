apex_lab_apple_id = data_bag_item('credentials', 'apple_id')
configurator_app_id = '1037126344'
BASE_COMMAND = '/usr/local/bin/mas'.freeze

execute 'Signin to App Store' do
  command "#{BASE_COMMAND} signin #{apex_lab_apple_id['apple_id']} #{apex_lab_apple_id['password']}"
  sensitive true
  not_if "#{BASE_COMMAND} account"
end

execute 'Install Configurator' do
  command "#{BASE_COMMAND} install #{configurator_app_id}"
  not_if "#{BASE_COMMAND} list | grep 'Apple Configurator'"
end

link '/usr/local/bin/cfgutil' do
  to '/Applications/Apple Configurator 2.app/Contents/MacOS/cfgutil'
  only_if File.exist?('/Applications/Apple Configurator 2.app')
end
