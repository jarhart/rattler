#
# = rattler/parsers/parser.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +Parser+ is the base class for all of Rattler's combinator parser types.
  #
  # @author Jason Arhart
  #
  class Parser < Rattler::Util::Node

    include Rattler::Runtime::ParserHelper

    # @private
    def self.parsed(*args) #:nodoc:
      self[*args]
    end

    # Return +true+ if the parser returns parse results on success, or
    # +false+ if the parser simply returns +true+ on success.
    #
    # @return [Boolean] +true+ if the parser returns parse results on
    #   success, or +false+ if the parser simply returns +true+ on success
    def capturing?
      true
    end

    def variable_capture_count?
      false
    end

    def capturing_decidable?
      true
    end

    # Return +true+ if the parser associates a label with parse results. Only
    # instances of +Label+ should return +true+.
    #
    # @return [Boolean] +true+ if the parser associates a label with parse results
    def labeled?
      false
    end

    def sequence?
      false
    end

    def semantic?
      false
    end

    # @param [Parser] other the parser to try if this parser fails.
    # @return a new parser that tries this parser first and if it fails tries
    #   +other+
    def |(other)
      Choice[self, other]
    end

    # @param [Parser] other the next parser to try if this parser succeeds.
    # @return a new parser that tries both this parser and +other+ and fails
    #   unless both parse in sequence
    def &(other)
      Sequence[self, other]
    end

    # @param [Parser] semantic a semantic action.
    # @return a new parser that tries this parser and returns the result of
    #   the semantic action if it succeeds
    def >>(semantic)
      AttributedSequence[self, semantic]
    end

    # @return a new parser that tries this parser but returns +true+ if it
    #   fails
    def optional
      Repeat[self, 0, 1]
    end

    # @return a new parser that tries this parser until it fails and returns
    #   all of the results
    def zero_or_more
      Repeat[self, 0, nil]
    end

    # @return a new parser that tries this parser until it fails and returns
    #   all of the results if it succeeded at least once and fails otherwise
    def one_or_more
      Repeat[self, 1, nil]
    end

    # @return a new parser that skips over what this parser matches
    def skip
      Skip[self]
    end

    # @param [Parser] ws the parser used to skip whitespace
    # @return [Parser] a new parser that uses +ws+ to skip whitespace
    def with_ws(ws)
      self
    end

  end
end
