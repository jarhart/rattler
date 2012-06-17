require 'rattler/parsers'

module Rattler::Parsers

  # +CombinatorParser+ is a runtime parser that parses using the parse rules
  # directly instead of using match methods generated from the parse rules
  class CombinatorParser < Rattler::Runtime::Parser

    # @param [Symbol] start_rule the initial rule to use for parsing
    # @param [RuleSet] rule_set the set of rules to use for parsing
    #
    # @return [Class] a subclass of +CombinatorParser+ that uses the given
    #   start rule and rule set and can be instantiated with only a source
    def self.as_class(start_rule, rule_set)
      new_class = Class.new(self)
      new_class.send :define_method, :initialize do |source|
        super source, start_rule, rule_set
      end
      new_class
    end

    # Create a new +CombinatorParser+ to parse +source+ using +rule_set+ and
    # starting with +start_rule+
    #
    # @param [String] source the source to parse
    # @param [Symbol] start_rule the initial rule to use for parsing
    # @param [RuleSet] rule_set the set of rules to use for parsing
    def initialize(source, start_rule, rule_set)
      super source
      @start_rule = start_rule
      @rule_set = rule_set
    end

    # (see Rattler::Runtime::RecursiveDescentParser#__parse__)
    def __parse__
      @start_rule.parse(@scanner, @rule_set)
    end

  end
end
