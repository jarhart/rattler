require 'rattler/parsers'

module Rattler::Parsers

  # +Match+ parses by matching with a +Regexp+. If the +Regexp+ matches at
  # the parse position the entire matched string is returned, otherwise the
  # parse fails.
  class Match < Parser
    include Atomic

    # @param [Regexp] re the pattern to match
    # @return [Match] a new match parser that matches with +re+
    def self.[](re)
      self.new(:re => re)
    end

    # @private
    def self.parsed(results, *_) #:nodoc:
      self[eval(results.first)]
    end

    # If the +Regexp+ matches at the parse position, return the matched
    # string, otherwise return a false value.
    #
    # @param [StringScanner] scanner the scanner for the current parse
    # @param [RuleSet] rules the grammar rules being used for the current parse
    # @param [ParserScope] scope the scope of captured results
    #
    # @return the matched string, or +nil+
    def parse(scanner, rules, scope = ParserScope.empty)
      scanner.scan re
    end

  end
end
