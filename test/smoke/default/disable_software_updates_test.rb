require_relative 'system_preference'
plist_path = "#{SYSTEM_PREFERENCES}/com.apple.SoftwareUpdate.plist"

settings_to_test = { 'AutomaticCheckEnabled' => false,
                     'AutomaticDownload' => false,
                   }

settings_to_test.each do |preference_key, preference_value|
  describe command("/usr/libexec/Plistbuddy -c 'Print #{preference_key}' #{plist_path}") do
    its('stdout') { should match /#{preference_value}/ }
  end
end
