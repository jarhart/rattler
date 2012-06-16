require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator
  # @private
  class RuleGenerator #:nodoc:

    Grammar = Rattler::Grammar::Grammar
    include Rattler::Parsers

    def initialize(g)
      @g = g
      @expr_generator = NestedExprGenerator.new(@g)
    end

    def generate(rule, opts={})
      (@g << "# @private").newline
      @g.block "def match_#{rule.name} #:nodoc:" do
        @g << "apply :match_#{rule.name}!"
      end.newline.newline
      gen_match_method rule
    end

    private

    def gen_match_method(rule)
      (@g << "# @private").newline
      @g.block "def match_#{rule.name}! #:nodoc:" do
        gen_child rule.child
        gen_fail rule if add_implicit_fail? rule
      end
    end

    def add_implicit_fail?(rule)
      not (rule.attrs[:inline] or has_explicit_fail?(rule.child))
    end

    def gen_child(child)
      if child.is_a? Choice
        @expr_generator.gen_top_level child
      else
        @expr_generator.generate child
      end
    end

    def gen_fail(rule)
      (@g << " ||").newline
      if force_fail_message? rule.child
        @g << "fail! { :#{rule.name} }"
      else
        @g << "fail { :#{rule.name} }"
      end
    end

    def force_fail_message?(expr)
      expr.is_a? Choice and
      expr.any? {|_| _.is_a? Apply or force_fail_message? _ }
    end

    def has_explicit_fail?(expr)
      case expr
      when Fail then true
      when Choice then expr.any? {|_| has_explicit_fail? _ }
      end
    end

  end
end
