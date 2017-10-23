xcode node['macos']['xcode']['version'] do
  ios_simulators node['macos']['xcode']['simulator']['major_version']
end
