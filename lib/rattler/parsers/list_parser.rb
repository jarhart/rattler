#
# = rattler/parsers/list.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +ListParser+ matches terms matched by a term parser in a list with
  # separators matched by a separator parser.
  #
  # @author Jason Arhart
  #
  class ListParser < Parser
    include Combining

    # @private
    def self.parsed(results, *_) #:nodoc:
      self[*results]
    end

    # Create a new list parser that matches terms with +term_parser+ and
    # separators with +sep_parser+
    def self.[](term_parser, sep_parser)
      self.new(term_parser, sep_parser.skip)
    end

    def term_parser
      children[0]
    end

    def sep_parser
      children[1]
    end

    # Parse terms matched by the term parser in a list with separators matched
    # by the separator parser. Return the terms in an array, or +true+ if the
    # term parser is not <tt>capturing?</tt>.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return [Array, true] an array containing the term parser's parse results,
    #   or +true+ if the term parser is not <tt>capturing?</tt>
    def parse(scanner, rules, scope = {})
      a = []
      p = scanner.pos
      while result = term_parser.parse(scanner, rules, scope)
        p = scanner.pos
        a << result
        break unless sep_parser.parse(scanner, rules, scope)
      end
      scanner.pos = p
      (capturing? ? a : true) if enough? a
    end

    def variable_capture_count?
      true
    end

  end
end
