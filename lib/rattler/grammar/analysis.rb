#
# = rattler/grammar/grammar.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/grammar'
require 'set'

module Rattler::Grammar
  class Analysis

    include Rattler::Parsers

    def initialize(rules)
      @rules = rules
      @references = {}
      @left_references = {}
      @direct_references = {}
      @direct_left_references = {}
      @has_super = {}
    end

    def regular?(rule_name)
      not recursive?(rule_name)
    end

    def recursive?(rule_name)
      has_super? rule_name or
      referenced_from? rule_name, rule_name
    end

    def left_recursive?(rule_name)
      left_referenced_from? rule_name, rule_name
    end

    def referenced?(rule_name)
      rule_name == @rules.start_rule or
      referenced_from? @rules.start_rule, rule_name
    end

    def referenced_from?(referencer, referencee)
      references_from(referencer).include? referencee
    end

    def left_referenced_from?(referencer, referencee)
      left_references_from(referencer).include? referencee
    end

    private

    def has_super?(rule_name)
      @has_super[rule_name] ||= expr_has_super?(@rules[rule_name].expr)
    end

    def expr_has_super?(expr)
      case expr
      when Super
        true
      when Rattler::Parsers::Parser
        expr.any? {|_| expr_has_super? _ }
      else
        false
      end
    end

    def references_from(rule_name)
      @references[rule_name] ||= trace_references rule_name, :direct_references
    end

    def left_references_from(rule_name)
      @left_references[rule_name] ||= trace_references rule_name, :direct_left_references
    end

    def trace_references(rule_name, enum, references=nil)
      references ||= Set[]
      for r in send(enum, @rules[rule_name].expr)
        trace_references(r, enum, references << r) unless references.include? r
      end
      references
    end

    def direct_references(expr)
      @direct_references[expr] ||= case expr
      when Apply
        Set[expr.rule_name]
      when Rattler::Parsers::Parser
        expr.map {|_| direct_references _ }.to_set.flatten
      else
        Set[]
      end
    end

    def direct_left_references(expr)
      @direct_left_references[expr] ||= case expr
      when Apply
        Set[expr.rule_name]
      when Choice
        expr.map {|_| direct_left_references _ }.to_set.flatten
      when Rattler::Parsers::Parser
        direct_left_references expr.child
      else
        Set[]
      end
    end

  end
end
