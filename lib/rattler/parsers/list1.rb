#
# = rattler/parsers/list1.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +List1+ matches terms matched by a term parser in a list with separators
  # matched by a separator parser. +List1+ fails unless at least one term is
  # matched.
  #
  # @author Jason Arhart
  #
  class List1 < Parser
    include Combining

    # @private
    def self.parsed(results, *_) #:nodoc:
      self[*results]
    end

    # Create a new list1 parser that matches terms with +term_parser+ and
    # separators with +sep_parser+
    def self.[](term_parser, sep_parser)
      self.new(term_parser, :sep_parser => sep_parser)
    end

    # Parse terms matched by the term parser in a list with separators matched
    # by the separator parser. Return the terms in an array, or +true+ if the
    # term parser is not <tt>capturing?</tt>, or +false+ if no terms matched..
    #
    # @param (see Parser#parse_labeled)
    #
    # @return [Array, true] an array containing the term parser's parse results,
    #   or +true+ if the term parser is not <tt>capturing?</tt>, or +false+ if
    #   no terms matched.
    def parse(scanner, rules, labeled = {})
      a = []
      p = scanner.pos
      while result = child.parse(scanner, rules)
        p = scanner.pos
        a << result
        break unless sep_parser.parse(scanner, rules)
      end
      scanner.pos = p
      (capturing? ? a : true) unless a.empty?
    end

    def variable_capture_count?
      true
    end

  end
end
