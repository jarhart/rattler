require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer
  module Optimizations
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
