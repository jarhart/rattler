require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer

  # +Optimizations+ defines the sequence of optimizations to apply to optimize
  # parsers
  module Optimizations

    # @return [Optimization] the sequence of optimizations to apply to optimize
    #   parsers
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
  end
end
