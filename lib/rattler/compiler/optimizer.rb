require 'rattler/compiler'

module Rattler::Compiler

  # The +Optimizer+ transforms parser models into equivalent models that can
  # result in more efficient parsing code. This is primarily achieved by
  # converting regular expressions into equivalent Regexp patterns, thus
  # reducing object instantiation and method dispatch and having StringScanner
  # do as much of the parsing work as possible.
  module Optimizer

    autoload :OptimizationContext, 'rattler/compiler/optimizer/optimization_context'
    autoload :Optimization, 'rattler/compiler/optimizer/optimization'
    autoload :OptimizationSequence, 'rattler/compiler/optimizer/optimization_sequence'
    autoload :InlineNonrecursiveRules, 'rattler/compiler/optimizer/inline_nonrecursive_rules'
    autoload :SimplifyRedundantRepeat, 'rattler/compiler/optimizer/simplify_redundant_repeat'
    autoload :RemoveMeaninglessWrapper, 'rattler/compiler/optimizer/remove_meaningless_wrapper'
    autoload :SimplifyTokenMatch, 'rattler/compiler/optimizer/simplify_token_match'
    autoload :FlattenSequence, 'rattler/compiler/optimizer/flatten_sequence'
    autoload :FlattenChoice, 'rattler/compiler/optimizer/flatten_choice'
    autoload :ReduceRepeatMatch, 'rattler/compiler/optimizer/reduce_repeat_match'
    autoload :JoinPredicateMatch, 'rattler/compiler/optimizer/join_predicate_match'
    autoload :JoinPredicateBareMatch, 'rattler/compiler/optimizer/join_predicate_bare_match'
    autoload :JoinPredicateNestedMatch, 'rattler/compiler/optimizer/join_predicate_nested_match'
    autoload :JoinPredicateOrMatch, 'rattler/compiler/optimizer/join_predicate_or_match'
    autoload :JoinPredicateOrBareMatch, 'rattler/compiler/optimizer/join_predicate_or_bare_match'
    autoload :JoinPredicateOrNestedMatch, 'rattler/compiler/optimizer/join_predicate_or_nested_match'
    autoload :JoinMatchSequence, 'rattler/compiler/optimizer/join_match_sequence'
    autoload :JoinMatchCapturingSequence, 'rattler/compiler/optimizer/join_match_capturing_sequence'
    autoload :JoinMatchMatchingSequence, 'rattler/compiler/optimizer/join_match_matching_sequence'
    autoload :JoinMatchChoice, 'rattler/compiler/optimizer/join_match_choice'
    autoload :MatchJoining, 'rattler/compiler/optimizer/match_joining'
    autoload :PredicateMatchJoining, 'rattler/compiler/optimizer/predicate_match_joining'
    autoload :PredicateBareMatchJoining, 'rattler/compiler/optimizer/predicate_bare_match_joining'
    autoload :PredicateNestedMatchJoining, 'rattler/compiler/optimizer/predicate_nested_match_joining'
    autoload :PredicateMatchSequenceJoining, 'rattler/compiler/optimizer/predicate_match_sequence_joining'
    autoload :PredicateMatchChoiceJoining, 'rattler/compiler/optimizer/predicate_match_choice_joining'
    autoload :Flattening, 'rattler/compiler/optimizer/flattening'
    autoload :CompositeReducing, 'rattler/compiler/optimizer/composite_reducing'

    class << self

      include Rattler::Parsers

      @@optimizations =
        InlineNonrecursiveRules >>
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

      # @param [Rattler::Parsers::Grammar, Rattler::Parsers::RuleSet, Rattler::Parsers::Rule, Rattler::Parsers::Parser]
      #   model the model to be optimized
      # @param [Hash] opts options for the optimizer
      # @return an optimized parser model
      def optimize(model, opts={})
        context = default_context(opts)
        case model
        when Grammar
          optimize_grammar(model, context)
        when RuleSet
          optimize_rule_set(model, context)
        when Rule
          optimize_rule(model, context)
        else
          optimize_parser(model, context)
        end
      end

      private

      def optimize_grammar(grammar, context)
        grammar.with_rules(optimize_rule_set(grammar.rules, context))
      end

      def optimize_rule_set(rule_set, context)
        context.with(
          :rules => rule_set.map_rules { |rule|
            optimize_rule(rule, context.with(:rules => rule_set))
          }
        ).relavent_rules
      end

      def optimize_rule(rule, context)
        rule.with_expr(optimize_parser(rule.expr, context))
      end

      def optimize_parser(parser, context)
        @@optimizations.deep_apply(parser, context)
      end

      def default_context(opts)
        OptimizationContext[opts.merge :type => :capturing].with(:rules => RuleSet[])
      end

    end
  end
end
