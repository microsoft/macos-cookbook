require 'spec_helper'

include MacOS::System

describe MacOS::System::FormFactor do
  context 'when passed a machine model that has MacMini' do
    it 'it registers as form factor type desktop' do
      ff = MacOS::System::FormFactor.new('MacMini')
      expect(ff.desktop?).to eq true
    end
  end

  context 'when passed a machine model that has MacMini' do
    it 'it does not register as form factor type portable' do
      ff = MacOS::System::FormFactor.new('MacMini')
      expect(ff.portable?).to eq false
    end
  end

  context 'when passed a machine model that has MacPro' do
    it 'it registers as form factor type desktop' do
      ff = MacOS::System::FormFactor.new('MacPro')
      expect(ff.desktop?).to eq true
    end
  end

  context 'when passed a machine model that has MacPro' do
    it 'it does not register as form factor type portable' do
      ff = MacOS::System::FormFactor.new('MacPro')
      expect(ff.portable?).to eq false
    end
  end

  context 'when passed a machine model that has iMac' do
    it 'it registers as form factor type desktop' do
      ff = MacOS::System::FormFactor.new('iMac')
      expect(ff.desktop?).to eq true
    end
  end

  context 'when passed a machine model that has iMac' do
    it 'it does not register as form factor type portable' do
      ff = MacOS::System::FormFactor.new('iMac')
      expect(ff.portable?).to eq false
    end
  end

  context 'when passed a machine model that has Macbook' do
    it 'registers as form factor type portable' do
      ff = MacOS::System::FormFactor.new('Macbook')
      expect(ff.portable?).to eq true
    end
  end

  context 'when passed a machine model that has Macbook' do
    it 'it does not register as form factor desktop' do
      ff = MacOS::System::FormFactor.new('Macbook')
      expect(ff.desktop?).to eq false
    end
  end

  context 'when passed a machine model that is unknown' do
    it 'it does not register as form factor desktop' do
      ff = MacOS::System::FormFactor.new('unknown')
      expect(ff.desktop?).to eq false
    end
  end

  context 'when passed a machine model that is unknown' do
    it 'it does not register as form factor portable' do
      ff = MacOS::System::FormFactor.new('unknown')
      expect(ff.portable?).to eq false
    end
  end
end

describe MacOS::System::Environment do
  context 'setting virtualization_systems to have key value pair: parallels, guest' do
    it 'returns running in a vm' do
      env = MacOS::System::Environment.new('parallels' => 'guest')
      expect(env.vm?).to eq true
    end
  end

  context 'setting virtualization_systems to empty' do
    it 'returns running in a vm' do
      env = MacOS::System::Environment.new({})
      expect(env.vm?).to eq true
    end
  end

  context 'setting virtualization_systems to have key value pair: vbox, host' do
    it 'returns not running in a vm' do
      env = MacOS::System::Environment.new('vbox' => 'host')
      expect(env.vm?).to eq false
    end
  end
end

describe MacOS::System::ScreenSaver do
  context 'querying a read for idleTime' do
    it 'returns a defaults read command' do
      screen = MacOS::System::ScreenSaver.new('vagrant')
      expect(screen.query('read').command).to eq ['defaults', '-currentHost', 'read', 'com.apple.screensaver', 'idleTime']
    end

    it 'returns a defaults read command' do
      screen = MacOS::System::ScreenSaver.new('vagrant')
      expect(screen.query('read').command).should_not eq ['defaults', '-currentHost', 'read-type', 'com.apple.screensaver', 'idleTime']
    end
  end

  context 'querying a read-type for idleTime' do
    it 'returns a defaults read-type command' do
      screen = MacOS::System::ScreenSaver.new('vagrant')
      expect(screen.query('read-type').command).to eq ['defaults', '-currentHost', 'read-type', 'com.apple.screensaver', 'idleTime']
    end

    it 'returns a defaults read-type command' do
      screen = MacOS::System::ScreenSaver.new('vagrant')
      expect(screen.query('read-type').command).should_not eq ['defaults', '-currentHost', 'read', 'com.apple.screensaver', 'idleTime']
    end
  end

  context 'when idleTime is 0 and its type is integer' do
    before do
      allow_any_instance_of(MacOS::System::ScreenSaver).to receive(:settings)
        .and_return(true)
    end

    it 'screensaver is disabled' do
      screen = MacOS::System::ScreenSaver.new('vagrant')
      expect(screen.disabled?).to eq true
    end
  end

  context 'when idleTime is not 0 or its type is not an integer' do
    before do
      allow_any_instance_of(MacOS::System::ScreenSaver).to receive(:settings)
        .and_return(false)
    end

    it 'screensaver is not disabled' do
      screen = MacOS::System::ScreenSaver.new('vagrant')
      expect(screen.disabled?).to eq false
    end
  end
end
