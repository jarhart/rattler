#
# = rattler/parsers/token.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # Token decorates a parser to return the entire matched string
  #
  # @author Jason Arhart
  #
  class Token < Parser
    
    # If the decorated parser matches return the entire matched string,
    # otherwise return a false value.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return (see Match#parse)
    def parse(scanner, rules, labeled = {})
      p = scanner.pos
      child.parse(scanner, rules) && scanner.string[p...(scanner.pos)]
    end
    
    # @param (see Parser#with_ws)
    # @return (see Parser#with_ws)
    def with_ws(ws)
      Skip[ws] & self
    end
    
    # @return (see Parser#optimized)
    def optimized
      Token[child.token_optimized]
    end
    
    # @private
    def token_optimized #:nodoc:
      child.token_optimized
    end
    
    # @private
    def skip_optimized #:nodoc:
      child.skip_optimized
    end
    
  end
end
