require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  class RuleGenerator #:nodoc:

    Grammar = Rattler::Grammar::Grammar
    include Rattler::Parsers

    def initialize(g)
      @g = g
      @top_level_generator = TopLevelGenerator.new(@g)
    end

    def generate(parser, opts={})
      case parser
      when Rule then gen_rule_modular parser
      else @top_level_generator.generate parser
      end
      self
    end

    def gen_rule_standalone(rule, rule_set)
      if rule_set.analysis.left_recursive? rule.name
        gen_rule_hook rule, 'memoize_lr'
      elsif rule_set.analysis.recursive? rule.name
        gen_rule_hook rule, 'memoize'
      else
        gen_rule_method rule, "match_#{rule.name}"
      end
    end

    def gen_rule_modular(rule)
      gen_rule_hook rule, 'apply'
    end

    private

    def gen_rule_hook(rule, hook_name)
      (@g << "# @private").newline
      @g.block("def match_#{rule.name} #:nodoc:") do
        @g << "#{hook_name} :match_#{rule.name}!"
      end.newline.newline
      gen_rule_method rule, "match_#{rule.name}!"
    end

    def gen_rule_method(rule, method_name)
      (@g << "# @private").newline
      @g.block("def #{method_name} #:nodoc:") { generate rule.child }
    end

  end
end
