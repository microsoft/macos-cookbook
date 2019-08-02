if mac_os_x_after_high_sierra?
  xcode '11.0'

elsif mac_os_x_high_sierra?
  xcode '10.1' do
    ios_simulators %w(12 11)
  end
end
