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

    # If the decorated parser matches return the entire matched string,
    # otherwise return a false value.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return (see Match#parse)
    def parse(scanner, rules, labeled = {})
      p = scanner.pos
      child.parse(scanner, rules) && scanner.string[p...(scanner.pos)]
    end

    # @param (see Parser#with_ws)
    # @return (see Parser#with_ws)
    def with_ws(ws)
      ws.skip & self
    end

  end
end
