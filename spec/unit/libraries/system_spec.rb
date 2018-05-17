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
