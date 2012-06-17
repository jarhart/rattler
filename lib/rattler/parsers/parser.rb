require 'rattler/parsers'

module Rattler::Parsers

  # +Parser+ is the base class for all of Rattler's combinator parser types.
  class Parser < Rattler::Util::Node

    include Rattler::Runtime::ParserHelper

    # @private
    def self.parsed(*args) #:nodoc:
      self[*args]
    end

    # @return +true+ if the parser returns parse results on success, or +false+
    #   if the parser simply returns +true+ on success
    def capturing?
      true
    end

    # @return +true+ if the number of parse results returned by the parser
    #   varies based on the input
    def variable_capture_count?
      false
    end

    # @return +true+ if it can be determined statically whether the parser
    #   returns parse results on success
    def capturing_decidable?
      true
    end

    # +true+ if the parser associates a label with parse results. Only
    # instances of +Label+ should return +true+.
    #
    # @return +true+ if the parser associates a label with parse
    #   results
    def labeled?
      false
    end

    # @return +true+ if the parser is a sequence
    def sequence?
      false
    end

    # @return +true+ if the parser is a semantic action
    def semantic?
      false
    end

    # @param [Parser] other the parser to try if this parser fails.
    # @return [Choice] a new parser that tries this parser first and if it
    #   fails tries +other+
    def |(other)
      Choice[self, other]
    end

    # @param [Parser] other the next parser to try if this parser succeeds.
    # @return [Sequence] a new parser that tries both this parser and +other+
    #   and fails unless both parse in sequence
    def &(other)
      Sequence[self, other]
    end

    # @param [Parser] semantic a semantic action.
    # @return [AttributedSequence] a new parser that tries this parser and
    #   returns the result of the semantic action if it succeeds
    def >>(semantic)
      AttributedSequence[self, semantic]
    end

    # @param [Integer] lower_bound the minimum number of times to match
    # @param [Integer] upper_bound the maximum number of times to match
    # @return [Repeat] a new parser that tries this parser repeatedly
    def repeat(lower_bound, upper_bound)
      Repeat[self, lower_bound, upper_bound]
    end

    # @return [Repeat] a new parser that tries this parser but returns +true+
    #   if it fails
    def optional
      repeat(0, 1)
    end

    # @return [Repeat] a new parser that tries this parser until it fails
    #   and returns all of the results
    def zero_or_more
      repeat(0, nil)
    end

    # @return [Repeat] a new parser that tries this parser until it fails
    #   and returns all of the results if it succeeded at least once and fails
    #   otherwise
    def one_or_more
      repeat(1, nil)
    end

    # @param [Parser] sep_parser the parser for matching the list separator
    # @param [Integer] lower_bound the minimum number of times to match
    # @param [Integer] upper_bound the maximum number of times to match
    # @return [Repeat] a new parser that matches lists with this parser
    def list(sep_parser, lower_bound, upper_bound)
      ListParser[self, sep_parser, lower_bound, upper_bound]
    end

    # @return [Skip] a new parser that skips over what this parser matches
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
