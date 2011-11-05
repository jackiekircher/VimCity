require 'rspec/core/rake_task'

# rake spec
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/*_spec.rb'
  spec.rspec_opts = ['--color']
end

# rake doc
RSpec::Core::RakeTask.new(:doc) do |spec|
  spec.pattern = 'spec/*_spec.rb'
  spec.rspec_opts = ['--format documentation']
end

