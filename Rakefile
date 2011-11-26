# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

task :default => :test

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rattler"
  gem.homepage = "http://github.com/jarhart/rattler"
  gem.license = "MIT"
  gem.summary = %Q{Ruby Tool for Language Recognition}
  gem.description = %Q{Simple language recognition tool for Ruby based on packrat parsing}
  gem.email = "jarhart@gmail.com"
  gem.authors = ["Jason Arhart"]
  gem.files = FileList["{bin,lib}/**/*"]
  gem.test_files = FileList["{features,spec}/**/*"]
  gem.executables = ["rtlr"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'cucumber/rake/task'
Cucumber::Rake::Task.new do |t|
  if Cucumber::JRUBY
    t.profile = 'jruby'
  elsif Cucumber::WINDOWS_MRI
    t.profile = 'windows_mri'
  end
end

desc 'Run all tests'
task :test => [:spec, :cucumber]

if RUBY_VERSION.to_f == 1.8
  namespace :rcov do
    desc 'Run RSpec code examples with code coverage'
    RSpec::Core::RakeTask.new do |t|
      t.rcov = true
      t.rcov_opts = ['--exclude', 'gems/*,features,spec']
    end

    desc 'Run Cucumber features'
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

require 'yard'
YARD::Rake::YardocTask.new

desc 'Regenerate Metagrammar module from rattler.rtlr'
task :metagrammar => [:archive_metagrammar, :generate_metagrammar]

desc "delete generated files"
task :clobber do
  sh 'find . -name "*.rbc" -exec rm {} \;'
  sh 'rm -rf .rbx'
  sh 'rm -rf pkg'
  sh 'rm -rf doc'
  sh 'rm -rf coverage'
end

require 'rattler/rake_task'
Rattler::RakeTask.new :generate_metagrammar do |t|
  t.grammar = File.join *%w(lib rattler grammar rattler.rtlr)
  t.rtlr_opts = ['-l', 'lib', '-f']
end

task :archive_metagrammar do
  source_file = File.join 'lib', 'rattler', 'grammar', 'metagrammar.rb'
  timestamp = Time.now.strftime '%Y%m%d_%H%M%S'
  target_file = File.join 'archive', "metagrammar_#{timestamp}.rb"
  mkdir_p File.dirname(target_file)
  cp source_file, target_file
end
