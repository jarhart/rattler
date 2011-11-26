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
  # only applied if the referenced rule is regular and marked for inlining.
  #
  # @author Jason Arhart
  #
  class InlineRegularRules < Optimization

    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      parser.is_a? Apply and
      context.inlineable? parser.rule_name
    end

    def _apply(parser, context)
      context.rules[parser.rule_name].expr
    end

  end
end
