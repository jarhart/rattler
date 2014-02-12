require 'rspec/core'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

desc 'Run all tests'
task :test => [:spec, :cucumber]

RSpec::Core::RakeTask.new

Cucumber::Rake::Task.new do |t|
  if Cucumber::JRUBY
    t.profile = 'jruby'
  elsif Cucumber::WINDOWS_MRI
    t.profile = 'windows_mri'
  end
end

namespace :coverage do

  desc 'Run all tests with code coverage'
  task :test => [:spec, :cucumber]

  desc 'Run RSpec code examples with code coverage'
  task :spec do
    ENV['COVERAGE'] = 'true'
    Rake::Task['spec'].execute
  end

  desc 'Run Cucumber features with code coverage'
  task :cucumber do
    ENV['COVERAGE'] = 'true'
    Rake::Task['cucumber'].execute
  end
end
