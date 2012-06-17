require 'rattler/parsers'

module Rattler::Parsers

  # +Token+ decorates a parser to return the entire matched string
  class Token < Parser
    include Atomic

    # If the decorated parser matches return the entire matched string,
    # otherwise return a false value.
    #
    # @param (see Match#parse)
    #
    # @return (see Match#parse)
    def parse(scanner, rules, scope = ParserScope.empty)
      p = scanner.pos
      child.parse(scanner, rules, scope) && scanner.string[p...(scanner.pos)]
    end

  end
end
