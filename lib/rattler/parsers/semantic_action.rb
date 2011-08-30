module Rattler::Parsers
  class SemanticAction < Parser
    include Semantic

    def self.parsed(results, *_)
      self[results.first]
    end

    def self.[](code)
      self.new(:code => code.strip)
    end

    def parse(scanner, rules, scope = ParserScope.empty)
      apply scope
    end

    protected

    def create_bindable_code
      ActionCode.new(code)
    end

  end
end
