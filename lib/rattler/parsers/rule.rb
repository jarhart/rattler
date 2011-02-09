#
# = rattler/parsers/rule.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +Rule+ is a binding for a parser that can be referenced by name from
  # another rule.
  #
  # @author Jason Arhart
  #
  class Rule < Rattler::Util::Node
    
    # @private
    def self.parsed(results, *_) #:nodoc:
      self[*results]
    end
    
    # Create a new +Rule+.
    #
    # @param [Symbol, String] name the name of the new rule
    # @param [Parser] parser the parser that defines the rule body
    #
    # @return [Rule] a new parse rule
    def self.[](name, parser)
      self.new(parser, :name => name.to_sym)
    end
    
    # Parse using +scanner+ and +rules+ and on success return the result, on
    # failure return a false value.
    #
    # @param scanner (see Parser#parse_labeled)
    # @param rules (see Parser#parse_labeled)
    #
    # @return (see Parser#parse_labeled)
    def parse(scanner, rules)
      child.parse(scanner, rules)
    end
    
    # @param (see Parser#with_ws)
    # @return (see Parser#with_ws)
    def with_ws(ws)
      Rule[name, child.with_ws(ws)]
    end
    
    # @return (see Parser#optimized)
    def optimized
      Rule[name, child.optimized]
    end
    
  end
end
