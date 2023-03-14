require_relative '../../spec_helper'

describe MacOS::RemoteManagement do
  let(:shellout) { double(stdout: nil, stderr: nil) }

  describe '.current_mask' do
    context 'when ARD is currently configured to use global privileges' do
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

      it 'should retrieve the privilege value from global settings plist and return the equivalent mask' do
        allow(described_class).to receive(:global_settings_xml).and_return global_settings_xml
        expect(described_class.current_mask('bilbo')).to eq(-2147483645) # priv value: 3 -> priv mask: -2147483645
      end
    end
    context 'when ARD is currently configured to use individual privileges' do
      let(:dscl_naprivs) do
        <<~STDOUT
          bilbo   -2147483644
          gandalf -2147483644
        STDOUT
      end

      it 'should return the mask retrieved from `dscl`' do
        allow(described_class).to receive(:using_global_privileges?).and_return false
        allow(shellout).to receive(:stdout).and_return dscl_naprivs
        allow_any_instance_of(Chef::Mixin::ShellOut).to receive(:shell_out!).and_return shellout
        expect(described_class.current_mask(['bilbo', 'gandalf'])).to eq(-2147483644)
      end
    end
  end

  describe '.current_users_configured?' do
    context 'when using global settings' do
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

      it 'should return true when global privilege value exists' do
        allow(shellout).to receive(:stdout).and_return global_settings_xml
        allow_any_instance_of(Chef::Mixin::ShellOut).to receive(:shell_out!).and_return shellout
        expect(described_class.current_users_configured?(['bilbo'])).to be true
      end
    end
    context 'when using individual settings' do
      context 'when all desired users are configured' do
        it 'should return true' do
          allow(described_class).to receive(:using_global_privileges?).and_return false
          allow(described_class).to receive(:individual_settings).and_return({ 'bilbo' => 1 })
          expect(described_class.current_users_configured?(['bilbo'])).to be true
        end
      end
      context 'when desired users are not configured' do
        it 'should return false' do
          allow(described_class).to receive(:using_global_privileges?).and_return false
          allow(described_class).to receive(:individual_settings).and_return({ 'bilbo' => 1 })
          expect(described_class.current_users_configured?(['bilbo', 'frodo'])).to be false
        end
      end
    end

    describe '.users_have_identical_masks?' do
      before(:each) { allow(described_class).to receive(:using_global_privileges?).and_return false }

      context 'when the users have different privilege masks' do
        let(:dscl_naprivs) do
          <<~STDOUT
            bilbo   -2147483644
            gandalf -2147483648
          STDOUT
        end

        it 'should return false' do
          allow(shellout).to receive(:stdout).and_return dscl_naprivs
          allow_any_instance_of(Chef::Mixin::ShellOut).to receive(:shell_out!).and_return shellout
          expect(described_class.current_users_have_identical_masks?(['bilbo', 'gandalf'])).to be false
        end
      end
      context 'when the users have the same privilege masks' do
        let(:dscl_naprivs) do
          <<~STDOUT
            bilbo   -2147483644
            ganalf  -2147483644
          STDOUT
        end

        it 'should return true' do
          allow(shellout).to receive(:stdout).and_return dscl_naprivs
          allow_any_instance_of(Chef::Mixin::ShellOut).to receive(:shell_out!).and_return shellout
          expect(described_class.current_users_have_identical_masks?(['bilbo', 'ganalf'])).to be true
        end
      end
    end

    describe '.current_computer_info' do
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

  describe '.activated?' do
    context 'when the Remote Management launchd file does not exit' do
      it 'should return false' do
        allow(Chef).to receive(:node).and_return({'platform_version' => '12.6.3' })
        allow(RemoteManagement::TCC::State).to receive(:enabled?).and_return true
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).and_return false
        expect(described_class.activated?).to be false
      end
    end
    context 'when the tcc state is not enabled' do
      let(:tccstate_stdout) do
        <<~XML
          <?xml version=\"1.0\" encoding=\"UTF-8\"?>
          <!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
          <plist version=\"1.0\">
          <dict>
            <key>postEvent</key>
            <false/>
            <key>screenCapture</key>
            <false/>
          </dict>
          </plist>
        XML
      end

      it 'should return false' do
        allow(Chef).to receive(:node).and_return({'platform_version' => '12.6.3' })
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).and_return false
        allow(shellout).to receive(:stdout).and_return tccstate_stdout
        allow_any_instance_of(Chef::Mixin::ShellOut).to receive(:shell_out!).and_return shellout
        expect(described_class.activated?).to be false
      end
    end
  end
end

describe MacOS::RemoteManagement::Privileges do
  describe '.format_privileges' do
    it 'should strings to capitalized snakecase' do
      expect(described_class.format('OneRINGToRuleThemAll')).to eq [:ONE_RING_TO_RULE_THEM_ALL]
      expect(described_class.format('one__RING__to__find__them')).to eq [:ONE_RING_TO_FIND_THEM]
      expect(described_class.format('one RING to bring them all')).to eq [:ONE_RING_TO_BRING_THEM_ALL]
      expect(described_class.format('and-in-the-darkness-bind-them')).to eq [:AND_IN_THE_DARKNESS_BIND_THEM]
    end
  end

  describe '.valid?' do
    context 'when the privileges are valid' do
      it 'should return true' do
        expect(described_class.valid?(:TEXT_MESSAGES)).to be true
        expect(described_class.valid?([:SEND_FILES, :CHANGE_SETTINGS])).to be true
      end
    end
    context 'when the privileges are invalid' do
      it 'should return true' do
        expect(described_class.valid?(:NASGUL)).to be false
        expect(described_class.valid?([:goblin, :orc])).to be false
        expect(described_class.valid?([:SMAUG])).to be false
      end
    end
  end
end

describe MacOS::RemoteManagement::Privileges::Mask do
  describe '.valid?' do
    subject { described_class.new(mask: -2147483645) }

    context 'when the mask is valid' do
      it 'should return true' do
        expect(subject.valid?(-2147483645)).to be true
        expect(subject.valid?(-2147483552)).to be true
        expect(subject.valid?(-2147483508)).to be true
        expect(subject.valid?(-1073741569)).to be true
        expect(subject.valid?(-2147483648)).to be true
        expect(subject.valid?(-2147483392)).to be true
        expect(subject.valid?(-2147483391)).to be true
      end
    end
    context 'when the mask is invalid' do
      it 'should return false' do
        expect(subject.valid?(-1073725185)).to be false
        expect(subject.valid?(-2145386496)).to be false
        expect(subject.valid?(-2143813632)).to be false
        expect(subject.valid?(-2143813629)).to be false
      end
    end
  end

  describe '.to_a' do
    it 'should return an array of privilege strings coresponding to the privilege mask' do
      expect(described_class.new(mask: -2147483645).to_a).to contain_exactly('TextMessages', 'ControlObserve')
      expect(described_class.new(mask: -2147483552).to_a).to contain_exactly('OpenQuitApps', 'ChangeSettings')
      expect(described_class.new(mask: -2147483508).to_a).to contain_exactly('SendFiles', 'RestartShutDown', 'DeleteFiles')
      expect(described_class.new(mask: -1073741569).to_a).to contain_exactly('all')
      expect(described_class.new(mask: -2147483648).to_a).to contain_exactly('none')
    end
  end
end

describe MacOS::RemoteManagement::Privileges::Value do
  describe '.valid?' do
    subject { described_class.new(value: 0) }

    context 'when the value is valid' do
      it 'should return true' do
        expect(subject.valid?(3)).to be true
        expect(subject.valid?(96)).to be true
        expect(subject.valid?(140)).to be true
        expect(subject.valid?(0)).to be true
        expect(subject.valid?(1073742079)).to be true
      end
    end
    context 'when the mask is invalid' do
      it 'should return false' do
        expect(subject.valid?(512)).to be false
        expect(subject.valid?(888)).to be false
        expect(subject.valid?(1024)).to be false
        expect(subject.valid?(666)).to be false
      end
    end
  end

  describe '.to_a' do
    it 'should return an array of privilege strings coresponding to the privilege value' do
      expect(described_class.new(value: 3).to_a).to contain_exactly('TextMessages', 'ControlObserve')
      expect(described_class.new(value: 96).to_a).to contain_exactly('OpenQuitApps', 'ChangeSettings')
      expect(described_class.new(value: 140).to_a).to contain_exactly('SendFiles', 'RestartShutDown', 'DeleteFiles')
      expect(described_class.new(value: 1073742079).to_a).to contain_exactly('all')
      expect(described_class.new(value: 0).to_a).to contain_exactly('none')
    end
  end
end
