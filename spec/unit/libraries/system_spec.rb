require 'spec_helper'

include MacOS::System

describe MacOS::System::FormFactor do
  context 'when passed a machine model that has MacMini' do
    it 'it registers as form factor type desktop' do
      ff = MacOS::System::FormFactor.new('machine_model' => 'Macmini7,1')
      expect(ff.desktop?).to eq true
      expect(ff.portable?).to eq false
    end
  end

  context 'when passed a machine model that has MacPro' do
    it 'it registers as form factor type desktop' do
      ff = MacOS::System::FormFactor.new('machine_model' => 'MacPro6,1')
      expect(ff.desktop?).to eq true
      expect(ff.portable?).to eq false
    end
  end

  context 'when passed a machine model that has iMac' do
    it 'it registers as form factor type desktop' do
      ff = MacOS::System::FormFactor.new('machine_model' => 'iMac18,3')
      expect(ff.desktop?).to eq true
      expect(ff.portable?).to eq false
    end
  end

  context 'when passed a machine model that has Macbook' do
    it 'registers as form factor type portable' do
      ff = MacOS::System::FormFactor.new('machine_model' => 'MacBookPro14,3')
      expect(ff.portable?).to eq true
      expect(ff.desktop?).to eq false
    end
  end

  context 'when passed a machine model that is unknown' do
    it 'it does not register as form factor desktop' do
      ff = MacOS::System::FormFactor.new('machine_model' => 'unknown')
      expect(ff.desktop?).to eq false
      expect(ff.portable?).to eq false
    end
  end

  context 'when passed a machine model that is nil' do
    it 'it does not register as form factor desktop' do
      ff = MacOS::System::FormFactor.new(nil)
      expect(ff.desktop?).to eq false
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
  context 'With a user that has 10 mins as their idle time' do
      
    it 'returns disabled? as false' do
      idleTime = '10'

      expect(MacOS::System::ScreenSaver.disabled?(idleTime)).to eq false
    end
  end

  context 'querying a read-type for idleTime' do
    xit 'returns a defaults read-type command' do
      screen = MacOS::System::ScreenSaver.new('vagrant')
      expect(screen.query('read-type').command).to eq ['defaults', '-currentHost', 'read-type', 'com.apple.screensaver', 'idleTime']
    end
  end

  context 'when idleTime is 0' do
    before do
    end

    it 'returns disabled? as true' do
      idleTime = '0'

      expect(MacOS::System::ScreenSaver.disabled?(idleTime)).to eq true
    end

    xit 'screensaver is disabled' do
      screen = MacOS::System::ScreenSaver.new('vagrant')
      expect(screen.disabled?).to eq true
    end
  end

  context 'when idleTime is not 0 or its type is not an integer' do
    before do
      allow_any_instance_of(MacOS::System::ScreenSaver).to receive(:settings)
        .and_return(false)
    end

    xit 'screensaver is not disabled' do
      screen = MacOS::System::ScreenSaver.new('vagrant')
      expect(screen.disabled?).to eq false
    end
  end
end
