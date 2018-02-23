include Chef::Mixin::ShellOut

module MacOS
  class SecurityCommand
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
