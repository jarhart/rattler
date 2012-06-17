require 'rattler/parsers'

module Rattler::Parsers

  # +ListParser+ matches terms matched by a term parser in a list with
  # separators matched by a separator parser. +ListParser+ fails unless at
  # least <tt>#lower_bound</tt> terms are matched and stops matching at
  # <tt>#upper_bound</tt>.
  class ListParser < Parser
    include Combining

    # @private
    def self.parsed(results, *_) #:nodoc:
      term_parser, bounds, sep_parser = results
      self[term_parser, sep_parser, *bounds]
    end

    # @param [Parser] term_parser the parser for matching list terms
    # @param [Parser] sep_parser the parser for matching the list separator
    # @param [Integer] lower_bound the minimum number of terms to match
    # @param [Integer] upper_bound the maximum number of terms to match
    # @return [ListParser] a parser that matches lists
    def self.[](term_parser, sep_parser, lower_bound, upper_bound)
      self.new(term_parser, sep_parser.skip,
                :lower_bound => lower_bound, :upper_bound => upper_bound)
    end

    # @return [Parser] the parser for matching list terms
    def term_parser
      children[0]
    end

    # @return [Parser] the parser for matching the list separator
    def sep_parser
      children[1]
    end

    # Parse terms matched by the term parser in a list with separators matched
    # by the separator parser. Return the terms in an array, or +true+ if the
    # term parser is not <tt>capturing?</tt>. Fails returning false unless at
    # least <tt>#lower_bound</tt> terms are matched and stops matching at
    # <tt>#upper_bound</tt>.
    #
    # @param (see Match#parse)
    #
    # @return [Array or Boolean] an array containing the term parser's parse
    #   results, or +true+ if the term parser is not <tt>capturing?</tt> or
    #   +false+ if the parse fails.
    def parse(scanner, rules, scope = ParserScope.empty)
      a = []
      p = start_pos = scanner.pos
      while result = term_parser.parse(scanner, rules, scope) and
            (!upper_bound or a.size < upper_bound)
        p = scanner.pos
        a << result
        break unless sep_parser.parse(scanner, rules, scope)
      end
      if a.size >= lower_bound
        scanner.pos = p
        capturing? ? a : true
      else
        scanner.pos = start_pos
        false
      end
    end

    # @return [Fixnum] lower_bound the minimum number of terms to match
    def lower_bound?
      lower_bound > 0
    end

    # @return [Fixnum] upper_bound the maximum number of terms to match
    def upper_bound?
      not upper_bound.nil?
    end

    # @return +true+
    def variable_capture_count?
      true
    end

  end
end
