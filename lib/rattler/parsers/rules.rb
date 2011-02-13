#
# = rattler/parsers/rules.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  class Rules < Rattler::Util::Node
    
    # @private
    def self.parsed(results, *_) #:nodoc:
      self.new(results)
    end
    
    def initialize(*args)
      super
      @by_name = {}
      children.each {|rule| @by_name[rule.name] = rule }
    end
    
    attr_accessor :start_rule
    
    def rule(name)
      @by_name[name]
    end
    
    def [](*args)
      if args.length == 1 and args[0].is_a?(Symbol)
        rule(args[0])
      else
        super
      end
    end
    
    def optimized
      Rules[children.map {|_| _.optimized }]
    end
    
  end
end
