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
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  gem.add_development_dependency "rspec", ">= 2.0.0"
  gem.add_development_dependency "yard", ">= 0.6.2"
  gem.add_development_dependency "cucumber", ">= 0"
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
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
Cucumber::Rake::Task.new(:features)

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.options = ['--no-private']
end

desc 'Generate the metagrammar module from the Rattler metagrammar'
task :metagrammar => [:archive_metagrammar, :lib_path] do
  require 'rattler/runner'
  Rattler::Runner.run([METAGRAMMAR_SOURCE, '-d', 'lib', '-f'])
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
