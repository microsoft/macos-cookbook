require_relative '../../spec_helper'

describe MacOS::RemoteManagement do
  describe '.kickstart' do
    it 'should return correct executable path' do
      expect(described_class.kickstart).to eq '/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart'
    end
  end

  describe '.current_mask' do
    let(:shellout) { double(stdout: nil, stderr: nil) }

    context 'when ARD is currently configured to grant access to all local users' do
      let(:global_settings_xml) do
        <<~XML
        <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
          <plist version="1.0">
          <dict>
            <key>ARD_AllLocalUsers</key>
            <true/>
            <key>ARD_AllLocalUsersPrivs</key>
            <integer>3</integer>
            <key>allowInsecureDH</key>
            <true/>
          </dict>
          </plist>
        XML
      end

      it 'should return the retrieve the privilege value from global settings plist and return the equivalent mask' do
        allow(described_class).to receive(:global_settings_xml).and_return global_settings_xml
        expect(described_class.current_mask('bilbo')).to eq(-2147483645)
      end
    end
    context 'when ARD is currently configured to grant access to specified users' do
      before(:each) { allow(described_class).to receive(:configured_for_all_users?).and_return false }

      context 'when there is only one user' do
        context 'when the specified user currently does not have privileges set' do
          it 'should return an empty string' do
            allow(shellout).to receive(:stdout).and_return ''
            allow_any_instance_of(Chef::Mixin::ShellOut).to receive(:shell_out!).and_return shellout
            expect(described_class.current_mask('bilbo')).to eq ''
          end
        end
        context 'when the specified user currently has privileges set' do
          let(:dscl_naprivs) { 'bilbo   -2147483648' }

          it 'should return the mask retrieved from `dscl`' do
            allow(shellout).to receive(:stdout).and_return dscl_naprivs
            allow_any_instance_of(Chef::Mixin::ShellOut).to receive(:shell_out!).and_return shellout
            expect(described_class.current_mask('bilbo')).to eq(-2147483648)
          end
        end
      end
      context 'when there are multiple users' do
        context 'when the users have different privilege masks' do
          let(:dscl_naprivs) do
            <<~STDOUT
              bilbo   -2147483644
              gandalf -2147483648
            STDOUT
          end

          it 'should return an empty string' do
            allow(shellout).to receive(:stdout).and_return dscl_naprivs
            allow_any_instance_of(Chef::Mixin::ShellOut).to receive(:shell_out!).and_return shellout
            expect(described_class.current_mask('bilbo', 'gandalf')).to eq ''
          end
        end
        context 'when the users have the same privilege masks' do
          let(:dscl_naprivs) do
            <<~STDOUT
              bilbo   -2147483644
              ganalf  -2147483644
            STDOUT
          end

          it 'should return the shared privilege mask' do
            allow(shellout).to receive(:stdout).and_return dscl_naprivs
            allow_any_instance_of(Chef::Mixin::ShellOut).to receive(:shell_out!).and_return shellout
            expect(described_class.current_mask('bilbo', 'ganalf')).to eq(-2147483644)
          end
        end
        context 'when one of the users has not been setup yet' do
          let(:dscl_naprivs) do
            <<~STDOUT
              ganalf  -2147483644
            STDOUT
          end

          it 'should return an empty string' do
            allow(shellout).to receive(:stdout).and_return dscl_naprivs
            allow_any_instance_of(Chef::Mixin::ShellOut).to receive(:shell_out!).and_return shellout
            expect(described_class.current_mask('bilbo', 'ganalf')).to eq ''
          end
        end
      end
    end
  end

  describe '.current_computer_info' do
    let(:shellout) { double(stdout: nil, stderr: nil) }

    context 'when there is no computer info' do
      let(:computer_info_xml) do
        <<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>DOCAllowRemoteConnections</key>
          <false/>
        </dict>
        </plist>
        XML
      end

      it 'should return an empty array' do
        allow(shellout).to receive(:stdout).and_return computer_info_xml
        allow_any_instance_of(Chef::Mixin::ShellOut).to receive(:shell_out!).and_return shellout
        expect(described_class.current_computer_info).to eq []
      end
    end
    context 'when there is computer info' do
      let(:computer_info_xml) do
        <<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>DOCAllowRemoteConnections</key>
          <false/>
          <key>Text1</key>
          <string>bilbo</string>
          <key>Text2</key>
          <string>baggins</string>
          <key>Text3</key>
          <string></string>
          <key>Text4</key>
          <string></string>
        </dict>
        </plist>
        XML
      end

      it 'should return an empty array' do
        allow(shellout).to receive(:stdout).and_return computer_info_xml
        allow_any_instance_of(Chef::Mixin::ShellOut).to receive(:shell_out!).and_return shellout
        expect(described_class.current_computer_info).to eq ['bilbo', 'baggins']
      end
    end
  end
end

describe MacOS::RemoteManagement::BitMask do
  describe '.mask_from_privileges' do
    context 'when single privilege' do
      it 'should return the correct mask' do
        expect(described_class.mask_from_privileges(['text_messages'])).to eq(-2147483647)
        expect(described_class.mask_from_privileges(['restart_shut_down'])).to eq(-2147483520)
        expect(described_class.mask_from_privileges(['observe_only'])).to eq(-2147483392)
        expect(described_class.mask_from_privileges(['show_observe'])).to eq(-1073741824)
      end
    end
    context 'when subset of privileges privileges' do
      it 'should return the correct mask' do
        expect(described_class.mask_from_privileges(['text_messages', 'control_observe'])).to eq(-2147483645)
        expect(described_class.mask_from_privileges(['open_quit_apps', 'change_settings'])).to eq(-2147483552)
        expect(described_class.mask_from_privileges(['send_files', 'restart_shut_down', 'delete_files'])).to eq(-2147483508)
        expect(described_class.mask_from_privileges(['all', 'text_messages'])).to eq(-1073741569)
        expect(described_class.mask_from_privileges(['none', 'text_messages'])).to eq(-2147483648)
      end
    end
    context 'when all privileges' do
      it 'should return correct mask' do
        expect(described_class.mask_from_privileges(['all'])).to eq(-1073741569)
      end
    end
    context 'when no privileges' do
      it 'should return correct mask' do
        expect(described_class.mask_from_privileges(['none'])).to eq(-2147483648)
      end
    end
    context 'when invalid privilege is passed' do
      it 'should throw argument error' do
        expect { described_class.mask_from_privileges(['nazgûl']) }.to raise_error(MacOS::RemoteManagement::Exceptions::BitMask::PrivilegeValidationError)
        expect { described_class.mask_from_privileges(['nazgûl', 'smèagol']) }.to raise_error(MacOS::RemoteManagement::Exceptions::BitMask::PrivilegeValidationError)
      end
    end
  end

  describe '.value_from_privileges' do
    context 'when single privilege' do
      it 'should return correct value' do
        expect(described_class.value_from_privileges(['control_observe'])).to eq 2
      end
    end
    context 'when subset of privileges' do
      it 'should return correct value' do
        expect(described_class.value_from_privileges(['text_messages', 'control_observe'])).to eq 3
        expect(described_class.value_from_privileges(['open_quit_apps', 'change_settings'])).to eq 96
        expect(described_class.value_from_privileges(['send_files', 'restart_shut_down', 'delete_files'])).to eq 140
        expect(described_class.value_from_privileges(['all', 'text_messages'])).to eq 1073742079
        expect(described_class.value_from_privileges(['none', 'text_messages'])).to eq 0
      end
    end
    context 'when all privileges' do
      it 'should return correct value' do
        expect(described_class.value_from_privileges(['all'])).to eq 1073742079
      end
    end
    context 'when no privileges' do
      it 'should return correct value' do
        expect(described_class.value_from_privileges(['none'])).to eq 0
      end
    end
  end

  describe '.valid_mask' do
    context 'when the mask is valid' do
      it 'should return true' do
        expect(described_class.valid_mask?(-2147483645)).to be true
        expect(described_class.valid_mask?(-2147483552)).to be true
        expect(described_class.valid_mask?(-2147483508)).to be true
        expect(described_class.valid_mask?(-1073741569)).to be true
        expect(described_class.valid_mask?(-2147483648)).to be true
        expect(described_class.valid_mask?(-2147483392)).to be true
        expect(described_class.valid_mask?(-2147483391)).to be true
      end
    end
    context 'when the mask is invalid' do
      it 'should return false' do
        expect(described_class.valid_mask?(-1073725185)).to be false
        expect(described_class.valid_mask?(-2145386496)).to be false
        expect(described_class.valid_mask?(-2143813632)).to be false
        expect(described_class.valid_mask?(-2143813629)).to be false
      end
    end
  end

  describe '.format_privileges' do
    it 'should strings to capitalized snakecase' do
      expect(described_class.format_privileges('OneRINGToRuleThemAll')).to eq [:ONE_RING_TO_RULE_THEM_ALL]
      expect(described_class.format_privileges('one__RING__to__find__them')).to eq [:ONE_RING_TO_FIND_THEM]
      expect(described_class.format_privileges('one RING to bring them all')).to eq [:ONE_RING_TO_BRING_THEM_ALL]
      expect(described_class.format_privileges('and-in-the-darkness-bind-them')).to eq [:AND_IN_THE_DARKNESS_BIND_THEM]
    end
  end
end
