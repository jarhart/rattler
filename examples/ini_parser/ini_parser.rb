#! /usr/bin/env ruby

require 'rubygems'
require 'rattler'
require File.expand_path('ini_grammar', File.dirname(__FILE__))

class IniParser < Rattler::Runtime::PackratParser

  include IniGrammar

  def initialize(*_)
    super
    @properties = {}
  end

  def property(name, value)
    @properties[@section ? "#{@section}.#{name}" : name.to_s] = value
  end

  def section(name)
    @section = name
  end

  def unquote(s)
    # simple way to remove the outer quotes that we know will be there
    eval(s, TOPLEVEL_BINDING)
  end
  
end

if __FILE__ == $0
  filename = File.expand_path('example.ini', File.dirname(__FILE__))
  ini = File.open(filename) {|io| io.read }
  begin
    for name, value in IniParser.parse!(ini)
      puts "#{name}: #{value.inspect}"
    end
  rescue Rattler::Runtime::SyntaxError => e
    puts e
  end
end
