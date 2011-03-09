#
# = rattler/parsers/one_or_more.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +OneOrMore+ decorates a parser to match repeatedly and succeed if the
  # decorated parser succeeds at least once.
  #
  # @author Jason Arhart
  #
  class OneOrMore < Parser
    include Combining

    # Parse using the wrapped parser repeatedly until it fails. If the
    # wrapped parser succeeds at least once return the results in an array,
    # or +true+ if the wrapped parser is not <tt>capturing?</tt>.  Return
    # +false+ if the wrapped parser does not succeed at least once.

    # Parse using the decorated parser as many times as it succeeds. If it does
    # not succeeds at least once return +false+, otherwise the results in an
    # array, or +true+ if the decorated parser is not <tt>capturing?</tt>.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return [Array, Boolean] an array containing the decorated parser's parse
    #   results, or +true+ if the decorated parser is not <tt>capturing?</tt>,
    #   or +false+ if the decorated parser does not succeed at least once.
    def parse(scanner, rules, labeled = {})
      a = []
      while result = child.parse(scanner, rules)
        a << result
      end
      (capturing? ? a : true) unless a.empty?
    end

    def variable_capture_count?
      true
    end

  end
end
