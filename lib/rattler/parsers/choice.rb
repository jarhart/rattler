
require 'rattler/parsers'

module Rattler::Parsers

  # +Choice+ combines two or more parsers and matches by trying each one in
  # order until one succeeds and returning that result.
  class Choice < Parser
    include Combining

    # @private
    def self.parsed(results, *_) #:nodoc:
      results.reduce(:|)
    end

    # Try each parser in order until one succeeds and return that result.
    #
    # @param (see Match#parse)
    #
    # @return the result of the first parser that matches, or +false+
    def parse(scanner, rules, scope = ParserScope.empty)
      for child in children
        if r = child.parse(scanner, rules, scope)
          return r
        end
      end
      false
    end

    # (see Parser#capturing_decidable?)
    def capturing_decidable?
      @capturing_decidable ||=
        children.all? {|_| _.capturing_decidable? } and
        ( children.all? {|_| _.capturing? } or
          children.none? {|_| _.capturing? } )
    end

    # Return a new parser that tries this parser first and if it fails tries
    # +other+.
    #
    # @param other (see Parser#|)
    # @return (see Parser#|)
    def |(other)
      Choice[(children + [other])]
    end

  end
end
