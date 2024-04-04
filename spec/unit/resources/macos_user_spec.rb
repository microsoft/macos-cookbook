require 'spec_helper'

describe 'macos_user hidden with a securetoken' do
  step_into :macos_user

  platform 'mac_os_x', '11'

  before do
    stubs_for_provider('macos_user[create user with secure token]') do |provider|
      allow(provider).to receive_shell_out('/usr/sbin/sysadminctl', '-adminUser', 'vagrant', '-adminPassword',
                                           'vagrant', '-addUser', 'carl', '', '-password', 'philemon', '',
                                           stderr: 'Creating user record…', exitstatus: 0)
      allow(provider).to receive_shell_out('/usr/sbin/sysadminctl', '-secureTokenStatus', 'carl',
                                           stderr: 'Secure token is ENABLED for user carl', exitstatus: 0)
    end
    stubs_for_resource('execute[hide user carl]') do |resource|
      allow(resource).to receive_shell_out('/usr/bin/dscl', '.', 'read', '/Users/carl', 'IsHidden')
    end
  end

  recipe do
    macos_user 'create user with secure token' do
      username 'carl'
      password 'philemon'
      hidden true
      secure_token true
      existing_token_auth({ username: 'vagrant', password: 'vagrant' })
    end
  end

  it { is_expected.to create_macos_user('create user with secure token') }
  it { is_expected.to run_execute('hide user carl') }
end

describe 'macos_user with a weak password on machine with a password policy' do
  step_into :macos_user

  platform 'mac_os_x', '11'

  before do
    stubs_for_provider('macos_user[create user with a weak password]') do |provider|
      allow(provider).to receive_shell_out('/usr/sbin/sysadminctl', '', '-addUser', 'new', '', '-password', '123', '',
                                           stderr: 'New account password error', exitstatus: 0)
    end
  end

  recipe do
    macos_user 'create user with a weak password' do
      username 'new'
      password '123'
    end
  end

  it 'raises an error' do
    expect { subject }.to raise_error(RuntimeError, /New account password error/)
  end
end

describe 'macos_user with no password on machine without a password policy' do
  step_into :macos_user

  platform 'mac_os_x', '11'

  before do
    stubs_for_provider('macos_user[create user with no password]') do |provider|
      allow(provider).to receive_shell_out('/usr/sbin/sysadminctl', '', '-addUser', 'cloudtest', '', '', '',
                                           stderr: 'creating user record…', exitstatus: 0)
      allow(provider).to receive_shell_out('/usr/sbin/sysadminctl', '-secureTokenStatus', 'cloudtest',
                                           stderr: 'Secure token is DISABLED for user cloudtest', exitstatus: 0)
    end
    stubs_for_resource('execute[clear any existing password policies]') do |resource|
      allow(resource).to receive_shell_out('pwpolicy getaccountpolicies', stdout: <<~PLIST
                                                                                    <?xml version="1.0" encoding="UTF-8"?>
                                                                                    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
                                                                                    <plist version="1.0">
                                                                                      <dict>
                                                                                        <key>policyCategoryPasswordContent</key>
                                                                                        <array>
                                                                                          <dict>
                                                                                            <key>policyContent</key>
                                                                                            <string>policyAttributePassword matches '.{8,}'</string>
                                                                                            <key>policyContentDescription</key>
                                                                                          </dict>
                                                                                        </array>
                                                                                      </dict>
                                                                                    </plist>
                                                                                  PLIST
      )
    end
  end

  recipe do
    macos_user 'create user with no password' do
      username 'cloudtest'
      secure_token false
      autologin true
    end
  end

  it { is_expected.to create_macos_user('create user with no password') }
end

describe 'macos_user attempting to delete the last secure token user' do
  step_into :macos_user

  platform 'mac_os_x', '11'

  before do
    stubs_for_provider('macos_user[owner]') do |provider|
      allow(provider).to receive(:user_already_exists?).and_return(true)
      allow(provider).to receive_shell_out('/usr/sbin/sysadminctl', '-deleteUser', 'owner',
                                           stderr: "User owner can not be deleted (it's either last admin user or last secure token user neither of which can be deleted)", exitstatus: 0)
    end
  end

  recipe do
    macos_user 'owner' do
      action :delete
    end
  end

  it 'raises an error' do
    expect { subject }.to raise_error(RuntimeError, /can not be deleted/)
  end
end
