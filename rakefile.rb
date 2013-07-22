require "rspec/core/rake_task"

task default: :spec

module RSpec::Core
  RakeTask.new(:spec) do |config|
    config.verbose = false
    config.rspec_opts = ["--order rand"]
  end
end
