require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator
  # @private
  class RuleSetGenerator #:nodoc:

    Grammar = Rattler::Grammar::Grammar
    include Rattler::Parsers

    def initialize(g)
      @g = g
      @rule_generator = RuleGenerator.new(@g)
    end

    def generate(parser, opts={})
      gen_rules parser, opts
      self
    end

    def gen_rules(rules, opts={})
      gen_start_rule rules.start_rule if rules.start_rule
      @g.intersperse(rules, :newlines => 2) do |rule|
        @rule_generator.generate rule
      end
    end

    def gen_start_rule(start_rule)
      (@g << "# @private").newline
      @g.block('def start_rule #:nodoc:') { @g << ":#{start_rule}"}.newline
      @g.newline
    end

  end
end
