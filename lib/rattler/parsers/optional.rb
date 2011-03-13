#
# = rattler/parsers/optional.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +Optional+ decorates a parser to match the same but always succeed.
  #
  # @author Jason Arhart
  #
  class Optional < Parser
    include Combining

    # Parse using the decorated parser and always succeed. If the decorated
    # parser is <tt>capturing?</tt> return the result in an array, or an empty
    # array if the wrapped parser fails.  If the decorated parser is not
    # <tt>capturing?</tt> always return +true+.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return [Array, true] an array containing the decorated parser's parse
    #   results if it matches or an empty array if not, or always +true+ if the
    #   decorated parser is not <tt>capturing?</tt>
    def parse(scanner, rules, scope = {})
      if result = child.parse(scanner, rules, scope)
        capturing? ? [result] : true
      else
        capturing? ? [] : true
      end
    end

    def variable_capture_count?
      true
    end

  end
end
