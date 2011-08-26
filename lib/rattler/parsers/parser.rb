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

    # @return a new parser that tries this parser but returns +true+ if it
    #   fails
    def optional
      Optional[self]
    end

    # @return a new parser that tries this parser until it fails and returns
    #   all of the results
    def zero_or_more
      ZeroOrMore[self]
    end

    # @return a new parser that tries this parser until it fails and returns
    #   all of the results if it succeeded at least once and fails otherwise
    def one_or_more
      OneOrMore[self]
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
