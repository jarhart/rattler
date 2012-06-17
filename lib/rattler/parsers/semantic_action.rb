module Rattler::Parsers

  # +SemanticAction+ is a pseudo-parser that performs a semantic action by
  # evaluating ruby code in the context of a parser scope.
  class SemanticAction < Parser
    include Semantic

    # @private
    def self.parsed(results, *_) #:nodoc:
      self[results.first]
    end

    # @param [String] code ruby code that can be bound to a parser scope to
    #   perform an action
    # @return [SemanticAction] a pseudo-parser that performs a semantic action
    def self.[](code)
      self.new(:code => code.strip)
    end

    # Perform the semantic action in the context of +scope+
    #
    # @param (see Match#parse)
    #
    # @return the result of performing the semantic action in the context of
    #   +scope+
    def parse(scanner, rules, scope = ParserScope.empty)
      apply scope
    end

    protected

    # @return [ActionCode] an object that be bound to a parser scope to return
    #   ruby code that performs the action
    def create_bindable_code
      ActionCode.new(code)
    end

  end
end
