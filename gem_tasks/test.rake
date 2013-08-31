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

if RUBY_VERSION.to_f == 1.8
  namespace :rcov do
    desc 'Run RSpec code examples with code coverage'
    RSpec::Core::RakeTask.new do |t|
      t.rcov = true
      t.rcov_opts = ['--exclude', 'gems/*,features,spec']
    end

    desc 'Run Cucumber features with code coverage'
    Cucumber::Rake::Task.new do |t|
      if Cucumber::JRUBY
        t.profile = 'jruby'
      elsif Cucumber::WINDOWS_MRI
        t.profile = 'windows_mri'
      end
      t.rcov = true
      t.rcov_opts =  ['--exclude', 'gems/*,features,spec']
    end
  end
end
