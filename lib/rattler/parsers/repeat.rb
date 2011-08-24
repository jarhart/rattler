require 'rattler/parsers'

module Rattler::Parsers
  #
  # +Repeat+ decorates a parser with repeat counts to match repeatedly (up to
  # the upper bound, if given) and succeed if the decorated parser succeeds at
  # least as many times as specified by the lower bound.
  #
  # @author Jason Arhart
  #
  class Repeat < Parser
    include Combining

    def self.[](parser, lower_bound, upper_bound)
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
    # @param (see Parser#parse_labeled)
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
        capturing? ? a : true
      else
        scanner.pos = start_pos
        false
      end
    end

    def zero_or_more?
      lower_bound == 0 and not upper_bound?
    end

    def one_or_more?
      lower_bound == 1 and not upper_bound?
    end

    def optional?
      lower_bound == 0 and upper_bound == 1
    end

    def lower_bound?
      lower_bound > 0
    end

    def upper_bound?
      not upper_bound.nil?
    end

    def variable_capture_count?
      true
    end

  end
end
