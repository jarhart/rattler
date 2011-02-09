#
# = rattler/parsers/disallow.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +Disallow+ decorates a parser and succeeds if the decorated parser fails
  # and vice versa.
  #
  class Disallow < Predicate
    
    # Succeed and return +true+ if and only if decorated parser fails.  Never
    # consumes any input.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return [Boolean] +true+ if the decorated parser fails
    def parse(scanner, rules, labeled = {})
      pos = scanner.pos
      result = !child.parse(scanner, rules)
      scanner.pos = pos
      result
    end
    
    # Return a parser that parses identically but may have a more optimized
    # structure.
    #
    # @return a parser that parses identically but may have a more optimized
    #   structure
    def optimized
      Disallow[child.optimized]
    end
    
    # @private
    def as_match #:nodoc:
      Match[child.disallow_re] if Match === child
    end
    
  end
end
