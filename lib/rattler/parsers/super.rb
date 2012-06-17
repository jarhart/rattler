require 'rattler/parsers'

module Rattler::Parsers

  # +Super+ parses by applying the rule of the same name inherited from a
  # super-grammar.
  class Super < Parser

    # @param [Symbol] rule_name the name of the referenced rule
    #
    # @return [Apply] a new parser that parses by applying the rule
    #   referenced by +rule_name+ in a super-grammar
    def self.[](rule_name)
      self.new(:rule_name => rule_name.to_sym)
    end

    # Apply the parse rule of the same name inherited from a super-grammar.
    #
    # @param (see Match#parse)
    #
    # @return the result of applying parse rule of the same name inherited from
    #   a super-grammar
    def parse(scanner, rules, scope = ParserScope.empty)
      rules.inherited_rule(rule_name).parse(scanner, rules, scope)
    end

    # (see Parser#capturing_decidable?)
    def capturing_decidable?
      false
    end

  end
end
