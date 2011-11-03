#
# = rattler/back_end/optimizer/inline_regular_rules.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler'

module Rattler::BackEnd::Optimizer
  #
  # References to regular parse rules can be inlined without affecting how they
  # parse, assuming the referenced rule does not change. This optimization is
  # only applied if the referenced rule is explicitly marked for inlining or
  # the :standalone option is used.
  #
  # @author Jason Arhart
  #
  class InlineRegularRules < Optimization

    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      parser.is_a? Apply and
      inlineable? parser.rule_name, context
    end

    def _apply(parser, context)
      context.rules[parser.rule_name].expr
    end

    private

    def inlineable?(rule_name, context)
      inline_allowed? rule_name, context and
      context.analysis.regular? rule_name
    end

    def inline_allowed?(rule_name, context)
      context.standalone? or
      (rule = context.rules[rule_name] and rule.attrs[:inline])
    end

  end
end
