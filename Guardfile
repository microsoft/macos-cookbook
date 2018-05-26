guard :rspec, cmd: 'chef exec rspec' do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  path_to_library_spec = ->(filename) { "spec/unit/libraries/#{filename}_spec.rb" }
  watch(%r{^libraries/(.+)\.rb$}) { |m| path_to_library_spec.call(m[1]) }
  watch(%r{^resources/(.+)\.rb$}) { |m| path_to_library_spec.call(m[1]) }
  watch(%r{^resources/(.+)\.rb$}) { |m| "spec/unit/resources/#{m[1]}_spec.rb" }
  watch(%r{^recipes/(.+)\.rb$}) { |m| "spec/unit/recipes/#{m[1]}_spec.rb" }

  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)
end
