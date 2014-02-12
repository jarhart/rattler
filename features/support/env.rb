require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'simplecov' if ENV['COVERAGE']

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'rattler'

require 'rspec/expectations'
require 'aruba/cucumber'

::Grammars = {}
def Object.const_missing(name)
  ::Grammars[name] || super
end

Before do
  @aruba_timeout_seconds = 5
end
