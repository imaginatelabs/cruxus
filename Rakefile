require "rspec/core/rake_task"
require "rubocop/rake_task"

task default: [:rubocop, :spec]

desc "Run the specs."
RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
end

RuboCop::RakeTask.new
