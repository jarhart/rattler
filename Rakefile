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

METAGRAMMAR_SOURCE = File.join *%w(lib rattler grammar rattler.rtlr)
METAGRAMMAR_ARCHIVE = 'archive'

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
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

# RSpec::Core::RakeTask.new(:rcov) do |spec|
#   spec.pattern = 'spec/**/*_spec.rb'
#   spec.rcov = true
# end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new :features do |t|
  if Cucumber::JRUBY
    t.profile = 'jruby'
  elsif Cucumber::WINDOWS_MRI
    t.profile = 'windows_mri'
  end
end

task :default => :test

desc 'Run all tests'
task :test => [:spec, :features]

require 'yard'
YARD::Rake::YardocTask.new

desc 'Regenerate Metagrammar module from rattler.rtlr'
task :metagrammar => [:archive_metagrammar, :lib_path] do
  require 'rattler/runner'
  Rattler::Runner.run([METAGRAMMAR_SOURCE, '-l', 'lib', '-f', '-s'])
end

task :lib_path do
  lib_path = File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
  $LOAD_PATH.unshift lib_path unless $LOAD_PATH.include? lib_path
end

task :archive_metagrammar do
  source_file = File.join 'lib', 'rattler', 'grammar', 'metagrammar.rb'
  timestamp = Time.now.strftime '%Y%m%d_%H%M%S'
  target_file = File.join METAGRAMMAR_ARCHIVE, "metagrammar_#{timestamp}.rb"
  mkdir_p METAGRAMMAR_ARCHIVE
  cp source_file, target_file
end
