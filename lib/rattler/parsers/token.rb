#
# = rattler/parsers/token.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +Token+ decorates a parser to return the entire matched string
  #
  # @author Jason Arhart
  #
  class Token < Parser
    include Atomic

    # If the decorated parser matches return the entire matched string,
    # otherwise return a false value.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return (see Match#parse)
    def parse(scanner, rules, scope = ParserScope.empty)
      p = scanner.pos
      child.parse(scanner, rules, scope) && scanner.string[p...(scanner.pos)]
    end

  end
end
