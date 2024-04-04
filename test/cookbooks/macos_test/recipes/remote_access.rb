# TODO; do we want to add the TCC logic to the resource?

tcc_db_path = '/Library/Application Support/com.apple.TCC/TCC.db'

tcc_db_screensharing_entry = if node['platform_version'] >= '14'
                               "'com.apple.screensharing.agent',0,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,1700100444,NULL,NULL,'UNUSED',0);"
                             else
                               "'com.apple.screensharing.agent',0,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,1639743960);"
                             end

execute 'authorize screensharing client to utilize the kTCCServicePostEvent service' do
  command ['/usr/bin/sqlite3', tcc_db_path, "INSERT OR REPLACE INTO access VALUES('kTCCServicePostEvent',#{tcc_db_screensharing_entry}" ]
  not_if { RemoteManagement::TCC::DB.correct_privileges? }
  only_if { shell_out('/usr/sbin/system_profiler', 'SPSoftwareDataType').stdout.match?(Regexp.new('System Integrity Protection: Disabled')) }
end

execute 'authorize screensharing client to utilize the kTCCServiceScreenCapture service' do
  command ['/usr/bin/sqlite3', tcc_db_path, "INSERT OR REPLACE INTO access VALUES ('kTCCServiceScreenCapture',#{tcc_db_screensharing_entry}" ]
  not_if { RemoteManagement::TCC::DB.correct_privileges? }
  only_if { shell_out('/usr/sbin/system_profiler', 'SPSoftwareDataType').stdout.match?(Regexp.new('System Integrity Protection: Disabled')) }
end

remote_management 'activate and configure remote management for all users' do
  users 'all'
  privileges %w(text__messages ControlObserve send_files)
  computer_info ['Arkenstone', 'Gold']
  only_if { shell_out('/usr/sbin/system_profiler', 'SPSoftwareDataType').stdout.match?(Regexp.new('System Integrity Protection: Disabled')) }
end
