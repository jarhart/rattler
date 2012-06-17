require 'rattler/parsers'

module Rattler::Parsers

  # +Apply+ parses by applying a referenced parse rule.
  class Apply < Parser

    # @param [Symbol,String] rule_name the name of the referenced rule
    # @return [Apply] a new parser that parses by applying the rule
    #   referenced by +rule_name+
    def self.[](rule_name)
      self.new(:rule_name => rule_name.to_sym)
    end

    # @private
    def self.parsed(results) #:nodoc:
      self[results.first]
    end

    # Apply the parse rule referenced by the #rule_name.
    #
    # @param (see Match#parse)
    #
    # @return the result of applying the referenced parse rule
    def parse(scanner, rules, scope = ParserScope.empty)
      (rule = rules[rule_name]) && rule.parse(scanner, rules, scope)
    end

    # (see Parser#capturing_decidable?)
    def capturing_decidable?
      false
    end

  end
end
