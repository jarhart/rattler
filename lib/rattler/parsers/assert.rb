#
# = rattler/parsers/assert.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +Assert+ decorates a parser and succeeds or fails like the decorated
  # parser but never consumes any input.
  #
  # @author Jason Arhart
  #
  class Assert < Predicate
    
    # Succeed or fail like the decorated parser but do not consume any input
    # and return +true+ on success.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return [Boolean] +true+ if the decorated parser succeeds
    def parse(scanner, rules, labeled = {})
      pos = scanner.pos
      result = (child.parse(scanner, rules) && true)
      scanner.pos = pos
      result
    end
    
    # Return a parser that parses identically but may have a more optimized
    # structure.
    #
    # @return a parser that parses identically but may have a more optimized
    #   structure
    def optimized
      Assert[child.optimized]
    end
    
    # @private
    def as_match #:nodoc:
      Match[child.assert_re] if Match === child
    end
    
  end
end
