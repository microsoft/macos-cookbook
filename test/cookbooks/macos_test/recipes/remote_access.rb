tcc_db_path = '/Library/Application Support/com.apple.TCC/TCC.db'

execute 'authorize screensharing client to utilize the kTCCServicePostEvent service' do
  command ['/usr/bin/sqlite3', tcc_db_path, "INSERT OR REPLACE INTO access VALUES('kTCCServicePostEvent','com.apple.screensharing.agent',0,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,1639743960);" ]
  not_if { RemoteManagement.correct_tcc_db_privileges? }
  only_if { shell_out('/usr/sbin/system_profiler', 'SPSoftwareDataType').stdout.match?(Regexp.new('System Integrity Protection: Disabled')) }
end

execute 'authorize screensharing client to utilize the kTCCServiceScreenCapture service' do
  command ['/usr/bin/sqlite3', tcc_db_path, "INSERT OR REPLACE INTO access VALUES ('kTCCServiceScreenCapture','com.apple.screensharing.agent',0,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,1639743960);" ]
  not_if { RemoteManagement.correct_tcc_db_privileges? }
  only_if { shell_out('/usr/sbin/system_profiler', 'SPSoftwareDataType').stdout.match?(Regexp.new('System Integrity Protection: Disabled')) }
end

remote_management 'activate and configure remote management for all users' do
  users 'vagrant'
  privileges %w(control_observe open_quit_apps)
  computer_info ['Arkenstone', 'Gold']
  only_if { shell_out('/usr/sbin/system_profiler', 'SPSoftwareDataType').stdout.match?(Regexp.new('System Integrity Protection: Disabled')) }
end
