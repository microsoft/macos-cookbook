# ruby_block('set node simulator attributes') do
#   block do
#     def available_versions
#       shell_out!('/usr/local/bin/xcversion simulators').stdout
#     end
#
#     def simulator_list
#       available_versions.split(/\n/).map { |version| version.split[0...2] }
#     end
#
#     def included_major_simulator_version
#       version_matcher    = /\d{1,2}\.\d{0,2}\.?\d{0,3}/
#       sdks               = shell_out!('/usr/bin/xcodebuild -showsdks').stdout
#       included_simulator = sdks.match(/Simulator - iOS (?<version>#{version_matcher})/)
#       included_simulator[:version]
#     end
#
#     def major_version_to_install
#       offset = node['macos']['simulator']['previous_versions_to_install']
#       included_major_simulator_version.to_i - offset.to_i
#     end
#
#     def highest_eligible_simulator(simulators, major_version)
#       simulator_requirement = Gem::Dependency.new('iOS', "~> #{major_version}")
#       simulators.select { |name, version| simulator_requirement.match?(name, version) }.max.join(' ')
#     end
#
#     highest_eligible = highest_eligible_simulator(simulator_list, major_version_to_install)
#
#     already_installed = available_versions.include?("#{highest_eligible} Simulator (installed)")
#
#     node.default['macos']['simulator']['to_install']         = highest_eligible
#     node.default['macos']['simulator']['already_installed?'] = already_installed
#   end
# end
#
#
# execute 'Install additional iOS simulator' do
#   command lazy { "#{install}'#{node['macos']['simulator']['to_install']}'" }
#   not_if { node['macos']['simulator']['already_installed?'] }
# end
