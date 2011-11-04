#
# = rattler/back_end/optimizer.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler'

module Rattler::BackEnd
  #
  # The +Optimizer+ transforms parser models into equivalent models that can
  # result in more efficient parsing code. This is primarily achieved by
  # converting regular expressions into equivalent Regexp patterns, thus
  # reducing object instantiation and method dispatch and having StringScanner
  # do as much of the parsing work as possible.
  #
  # @author Jason Arhart
  #
  module Optimizer

    class << self
      def optimizations
        @optimizations ||=
          InlineRegularRules >>
          OptimizeChildren >>
          SimplifyRedundantRepeat >>
          RemoveMeaninglessWrapper >>
          SimplifyTokenMatch >>
          FlattenSequence >>
          FlattenChoice >>
          ReduceRepeatMatch >>
          JoinPredicateMatch >>
          JoinPredicateOrMatch >>
          JoinMatchSequence >>
          JoinMatchChoice
      end

      def optimize(model, opts={})
        case model
        when ::Rattler::Grammar::Grammar then optimize_grammar model, opts
        when ::Rattler::Parsers::RuleSet then optimize_rule_set model, opts
        when ::Rattler::Parsers::Rule then optimize_rule model, default_context(opts)
        else optimize_expr model, default_context(opts)
        end
      end

      private

      def default_context(opts)
        OptimizationContext[opts.merge :type => :capturing]
      end

      def optimize_grammar(grammar, opts)
        grammar.with_rules optimize_rule_set(grammar.rules, opts)
      end

      def optimize_rule_set(rule_set, opts)
        context = default_context(opts).with(:rules => rule_set)
        rule_set = rule_set.map_rules {|_| optimize_rule _, context }
        context = context.with(:rules => rule_set)
        rule_set.select_rules {|_| context.relavent? _ }
      end

      def optimize_rule(rule, context)
        rule.with_expr optimizations.apply(rule.expr, context)
      end

      def optimize_expr(expr, context)
        optimizations.apply rule.expr, context
      end

    end

    autoload :OptimizationContext, 'rattler/back_end/optimizer/optimization_context'
    autoload :Optimization, 'rattler/back_end/optimizer/optimization'
    autoload :OptimizeChildren, 'rattler/back_end/optimizer/optimize_children'
    autoload :InlineRegularRules, 'rattler/back_end/optimizer/inline_regular_rules'
    autoload :SpecializeRepeat, 'rattler/back_end/optimizer/specialize_repeat'
    autoload :SimplifyRedundantRepeat, 'rattler/back_end/optimizer/simplify_redundant_repeat'
    autoload :RemoveMeaninglessWrapper, 'rattler/back_end/optimizer/remove_meaningless_wrapper'
    autoload :SimplifyTokenMatch, 'rattler/back_end/optimizer/simplify_token_match'
    autoload :FlattenSequence, 'rattler/back_end/optimizer/flatten_sequence'
    autoload :FlattenChoice, 'rattler/back_end/optimizer/flatten_choice'
    autoload :ReduceRepeatMatch, 'rattler/back_end/optimizer/reduce_repeat_match'
    autoload :JoinPredicateMatch, 'rattler/back_end/optimizer/join_predicate_match'
    autoload :JoinPredicateBareMatch, 'rattler/back_end/optimizer/join_predicate_bare_match'
    autoload :JoinPredicateNestedMatch, 'rattler/back_end/optimizer/join_predicate_nested_match'
    autoload :JoinPredicateOrMatch, 'rattler/back_end/optimizer/join_predicate_or_match'
    autoload :JoinPredicateOrBareMatch, 'rattler/back_end/optimizer/join_predicate_or_bare_match'
    autoload :JoinPredicateOrNestedMatch, 'rattler/back_end/optimizer/join_predicate_or_nested_match'
    autoload :JoinMatchSequence, 'rattler/back_end/optimizer/join_match_sequence'
    autoload :JoinMatchCapturingSequence, 'rattler/back_end/optimizer/join_match_capturing_sequence'
    autoload :JoinMatchMatchingSequence, 'rattler/back_end/optimizer/join_match_matching_sequence'
    autoload :JoinMatchChoice, 'rattler/back_end/optimizer/join_match_choice'
    autoload :MatchJoining, 'rattler/back_end/optimizer/match_joining'
    autoload :Flattening, 'rattler/back_end/optimizer/flattening'
    autoload :CompositeReducing, 'rattler/back_end/optimizer/composite_reducing'

  end
end
