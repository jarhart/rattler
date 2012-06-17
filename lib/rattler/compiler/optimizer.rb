require 'rattler/compiler'

module Rattler::Compiler

  # The +Optimizer+ transforms parser models into equivalent models that can
  # result in more efficient parsing code. This is primarily achieved by
  # converting regular expressions into equivalent Regexp patterns, thus
  # reducing object instantiation and method dispatch and having StringScanner
  # do as much of the parsing work as possible.
  module Optimizer

    class << self

      include Rattler::Parsers

      # @param [Rattler::Parsers::Grammar, Rattler::Parsers::RuleSet, Rattler::Parsers::Rule, Rattler::Parsers::Parser]
      #   model the model to be optimized
      # @param [Hash] opts options for the optimizer
      # @return an optimized parser model
      def optimize(model, opts={})
        case model
        when Grammar then optimize_grammar model, opts
        when RuleSet then optimize_rule_set model, opts
        else optimizations.apply model, default_context(opts)
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
        rule_set = rule_set.map_rules {|_| optimizations.apply _, context }
        context = context.with(:rules => rule_set)
        rule_set.select_rules {|_| context.relavent? _ }
      end

    end

    autoload :OptimizationContext, 'rattler/compiler/optimizer/optimization_context'
    autoload :Optimization, 'rattler/compiler/optimizer/optimization'
    autoload :OptimizationSequence, 'rattler/compiler/optimizer/optimization_sequence'
    autoload :Optimizations, 'rattler/compiler/optimizer/optimizations'
    autoload :OptimizeChildren, 'rattler/compiler/optimizer/optimize_children'
    autoload :InlineRegularRules, 'rattler/compiler/optimizer/inline_regular_rules'
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
    autoload :Flattening, 'rattler/compiler/optimizer/flattening'
    autoload :CompositeReducing, 'rattler/compiler/optimizer/composite_reducing'

  end

  Optimizer.extend Optimizer::Optimizations

end
