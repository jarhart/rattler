require 'rattler/parsers'

module Rattler::Parsers

  # +Skip+ decorates a parser to skip over what it matches without capturing
  # the results
  #
  class Skip < Parser
    include Combining

    # @private
    def self.parsed(results, *_) #:nodoc:
      self[results.first]
    end

    # If the decorated parser matches return +true+, otherwise return a false
    # value.
    #
    # @param (see Match#parse)
    #
    # @return [Boolean] +true+ if the decorated parser matches at the parse
    #   position
    def parse(*args)
      child.parse(*args) && true
    end

    # @return false
    # @see Parser#capturing?
    def capturing?
      false
    end

    # @return true
    # @see Parser#capturing_decidable?
    def capturing_decidable?
      true
    end

    # @return (see Parser#skip)
    def skip
      self
    end

  end
end
