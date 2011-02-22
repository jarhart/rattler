#
# = rattler/parsers/list.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +List+ matches terms matched by a term parser in a list with separators
  # matched by a separator parser.  +List+ always matches even if there are no
  # matched terms.
  #
  # @author Jason Arhart
  #
  class List < Parser
    include Combining

    # @private
    def self.parsed(results, *_) #:nodoc:
      self[*results]
    end

    # Create a new list parser that matches terms with +term_parser+ and
    # separators with +sep_parser+
    def self.[](term_parser, sep_parser)
      self.new(term_parser, :sep_parser => sep_parser)
    end

    # Parse terms matched by the term parser in a list with separators matched
    # by the separator parser. Return the terms in an array, or +true+ if the
    # term parser is not <tt>capturing?</tt>.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return [Array, true] an array containing the term parser's parse results,
    #   or +true+ if the term parser is not <tt>capturing?</tt>
    def parse(scanner, rules, labeled = {})
      a = []
      p = scanner.pos
      while result = child.parse(scanner, rules)
        p = scanner.pos
        a << result
        break unless sep_parser.parse(scanner, rules)
      end
      scanner.pos = p
      capturing? ? a : true
    end

    def variable_capture_count?
      true
    end

  end
end
