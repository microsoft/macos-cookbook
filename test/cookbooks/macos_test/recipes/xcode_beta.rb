execute 'Disable Gatekeeper' do
  command ['spctl', '--master-disable']
end

xcode '9.4'
