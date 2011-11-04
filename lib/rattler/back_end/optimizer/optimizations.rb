require 'rattler'

module Rattler::BackEnd::Optimizer
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
