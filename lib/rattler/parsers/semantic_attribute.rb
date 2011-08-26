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
    def parse(scanner, rules, scope = ParserScope.empty)
      scope = scope.nest
      if r = child.parse(scanner, rules, scope) {|_| scope = _ }
        if child.capturing? and not child.sequence?
          scope = if child.variable_capture_count?
            scope.capture(*r)
          else
            scope.capture(r)
          end
        end
        apply(scope)
      end
    end

  end
end
