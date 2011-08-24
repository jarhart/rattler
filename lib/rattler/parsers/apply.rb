#
# = rattler/parsers/apply.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +Apply+ parses by applying a referenced parse rule.
  #
  # @author Jason Arhart
  #
  class Apply < Parser

    # Create a new parser that parses by applying the parse rule referenced
    # by +rule_name+.
    #
    # @param [Symbol] rule_name the name of the referenced rule
    #
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
    # @param (see Parser#parse_labeled)
    #
    # @return the result of applying the referenced parse rule
    def parse(scanner, rules, scope = ParserScope.empty)
      (rule = rules[rule_name]) && rule.parse(scanner, rules, scope)
    end

  end
end
