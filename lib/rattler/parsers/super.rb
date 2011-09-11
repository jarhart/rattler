require 'rattler/parsers'

module Rattler::Parsers

  class Super < Parser

    def self.[](rule_name)
      self.new(:rule_name => rule_name.to_sym)
    end

    def parse(scanner, rules, scope = ParserScope.empty)
      rules.inherited_rule(rule_name).parse(scanner, rules, scope)
    end

    def capturing_decidable?
      false
    end

  end

end
