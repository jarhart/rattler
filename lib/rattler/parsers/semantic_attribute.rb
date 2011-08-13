require 'rattler/parsers'

module Rattler::Parsers
  #
  # A +SemanticAttribute+ decorates a parser to peform a semantic action on
  # success.
  #
  # @author Jason Arhart
  #
  class SemanticAttribute < Parser
    include Semantic
    include Combining

    # If the wrapped parser matches at the parse position, return the result
    # of applying the semantic action, otherwise return a false value.
    #
    # @return the result of applying the semantic action, or a false value if
    #   the parse failed.
    def parse(scanner, rules, scope = {})
      if result = child.parse(scanner, rules, scope) {|_| scope = _ }
        if not capturing?
          apply([])
        elsif result.respond_to?(:to_ary)
          apply(result, scope)
        else
          apply([result], scope)
        end
      end
    end

  end
end
