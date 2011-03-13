#
# = rattler/parsers/skip.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +Skip+ decorates a parser to skip over what it matches without capturing
  # the results
  #
  class Skip < Parser

    # @private
    def self.parsed(results, *_) #:nodoc:
      self[results.first]
    end

    # If the decorated parser matches return +true+, otherwise return a false
    # value.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return [Boolean] +true+ if the decorated parser matches at the parse
    #   position
    def parse(scanner, rules, scope = {})
      child.parse(scanner, rules, scope) && true
    end

    # Always +false+
    # @return false
    def capturing?
      false
    end

    # Return a new parser that uses +ws+ to skip whitespace before matching
    # tokens.
    #
    # @param (see Parser#with_ws)
    # @return (see Parser#with_ws)
    def with_ws(ws)
      child.with_ws(ws).skip
    end

    # @return (see Parser#skip)
    def skip
      self
    end

  end
end
