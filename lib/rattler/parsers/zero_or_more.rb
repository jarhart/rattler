#
# = rattler/parsers/zero_or_more.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +ZeroOrMore+ decorates a parser to match repeatedly and always succeed.
  #
  # @author Jason Arhart
  #
  class ZeroOrMore < Parser
    include Combining

    # Parse using the decorated parser as many times as it succeeds. Return the
    # results in an array, or +true+ if the decorated parser is not
    # <tt>capturing?</tt>.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return [Array, true] an array containing the decorated parser's parse
    #   results, or +true+ if the decorated parser is not <tt>capturing?</tt>
    def parse(scanner, rules, labeled = {})
      a = []
      while result = child.parse(scanner, rules)
        a << result
      end
      capturing? ? a : true
    end

    def variable_capture_count?
      true
    end

  end
end
