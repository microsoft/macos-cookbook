if node['platform_version'].match? Regexp.union '10.13'
  include_recipe 'macos::xcode'

elsif node['platform_version'].match? Regexp.union '10.12'
  xcode '9.2' do
    ios_simulators %w(11 10)
  end

elsif node['platform_version'].match? Regexp.union '10.11'
  xcode '8.2.1' do
    ios_simulators %w(10 9)
  end
end
