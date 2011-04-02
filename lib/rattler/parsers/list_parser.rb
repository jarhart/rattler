#
# = rattler/parsers/list_parser.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +ListParser+ matches terms matched by a term parser in a list with
  # separators matched by a separator parser. +ListParser+ fails unless at
  # least <tt>#lower_bound</tt> terms are matched and stops matching at
  # <tt>#upper_bound</tt>.
  #
  # @author Jason Arhart
  #
  class ListParser < Parser
    include Combining

    # @private
    def self.parsed(results, *_) #:nodoc:
      term_parser, bounds, sep_parser = results
      self[term_parser, sep_parser, *bounds]
    end

    def self.[](term_parser, sep_parser, lower_bound, upper_bound)
      self.new(term_parser, sep_parser.skip,
                :lower_bound => lower_bound, :upper_bound => upper_bound)
    end

    def term_parser
      children[0]
    end

    def sep_parser
      children[1]
    end

    # Parse terms matched by the term parser in a list with separators matched
    # by the separator parser. Return the terms in an array, or +true+ if the
    # term parser is not <tt>capturing?</tt>. Fails returning false unless at
    # least <tt>#lower_bound</tt> terms are matched and stops matching at
    # <tt>#upper_bound</tt>.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return [Array, Boolean] an array containing the term parser's parse
    #   results, or +true+ if the term parser is not <tt>capturing?</tt> or
    #   +false+ if the parse fails.
    def parse(scanner, rules, scope = {})
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
