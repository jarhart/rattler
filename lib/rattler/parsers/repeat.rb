require 'rattler/parsers'

module Rattler::Parsers

  # +Repeat+ decorates a parser with repeat counts to match repeatedly (up to
  # the upper bound, if given) and succeed if the decorated parser succeeds at
  # least as many times as specified by the lower bound.
  class Repeat < Parser
    include Combining

    # @param [Parser] parser the parser to wrap and match with repeatedly
    # @param [Integer] lower_bound the minimum number of times to match
    # @param [Integer] upper_bound the maximum number of times to match
    # @return [Repeat] a parser that decorates +parser+ and matches repeatedly
    def self.[](parser, lower_bound, upper_bound = nil)
      self.new(parser, :lower_bound => lower_bound, :upper_bound => upper_bound)
    end

    # @private
    def self.parsed(results, *_) #:nodoc
      parser, bounds = results
      self[parser, *bounds]
    end

    # Parse using the wrapped parser repeatedly until it fails or the upper
    # bound is reached. If the wrapped parser succeeds at least as many times
    # as specified by the lower bound, return the results in an array, or
    # +true+ if the wrapped parser is not <tt>capturing?</tt>.  Return +false+
    # if the lower bound is not reached.
    #
    # @param (see Match#parse)
    #
    # @return [Array, Boolean] an array containing the decorated parser's parse
    #   results, or +true+ if the decorated parser is not <tt>capturing?</tt>,
    #   or +false+ if the decorated parser does not succeed up to the lower
    #   bound.
    def parse(scanner, rules, scope = ParserScope.empty)
      a = []
      start_pos = scanner.pos
      while result = child.parse(scanner, rules, scope)
        a << result
        break if upper_bound? and a.size >= upper_bound
      end
      if a.size >= lower_bound
        capturing? ? select_captures(a) : true
      else
        scanner.pos = start_pos
        false
      end
    end

    # @return +true+ if the bounds define a zero-or-more
    def zero_or_more?
      lower_bound == 0 and not upper_bound?
    end

    # @return +true+ if the bounds define a one-or-more parser
    def one_or_more?
      lower_bound == 1 and not upper_bound?
    end

    # @return +true+ if the bounds define an optional (zero-or-one) parser
    def optional?
      lower_bound == 0 and upper_bound == 1
    end

    # @return +true+ if there is a lower bound
    def lower_bound?
      lower_bound > 0
    end

    # @return +true+ if there is an upper bound
    def upper_bound?
      not upper_bound.nil?
    end

    # (see Parser#variable_capture_count?)
    def variable_capture_count?
      true
    end

  end
end
