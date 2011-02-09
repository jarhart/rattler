#
# = rattler/parsers/direct_action.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +DirectAction+ decorates a parser to peform a symantic action on success by
  # evaluating ruby code.
  #
  # @author Jason Arhart
  #
  class DirectAction < Parser
    include Combining
    
    def self.[](child, code)
      self.new(child, :code => code)
    end
    
    # @private
    def self.parsed(results, *_) #:nodoc:
      self[*results]
    end
    
    # If the wrapped parser matches at the parse position, return the result
    # of applying the symantic action, otherwise return a false value.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return the result of applying the symantic action, or a false value if
    #   the parse failed.
    def parse(scanner, rules, l = {})
      labeled = {}
      if result = child.parse(scanner, rules, labeled)
        if not capturing?
          apply([])
        elsif result.respond_to?(:to_ary)
          apply(result, labeled)
        else
          apply([result], labeled)
        end
      end
    end
    
    def bindable_code
      @bindable_code ||= ActionCode.new(code)
    end
    
    def bind(*args)
      bindable_code.bind(*args)
    end
    
    # @private
    def token_optimized #:nodoc:
      child.token_optimized
    end
    
    # @private
    def skip_optimized #:nodoc:
      child.skip_optimized
    end
    
    private
    
    def apply(results, labeled={})
      l = {}
      labeled.each {|k, v| l[k] = v.inspect }
      if child.variable_capture_count?
        eval(bind([results.inspect], l))
      else
        eval(bind(results.map {|_| _.inspect }, l))
      end
    end
    
  end
end
