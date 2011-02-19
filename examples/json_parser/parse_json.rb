#! /usr/bin/env ruby

require 'rubygems'
require 'rattler'
require File.expand_path('json_helper', File.dirname(__FILE__))
require File.expand_path('json_parser', File.dirname(__FILE__))

json = File.open(File.expand_path(ARGV[0])) {|io| io.read }
begin
  p JsonParser.parse!(json)
rescue Rattler::Runtime::SyntaxError => e
  puts e
end
