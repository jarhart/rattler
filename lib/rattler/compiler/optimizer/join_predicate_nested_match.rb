require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer

  # A predicate and an adjacent skip of a Regexp match in a Sequence can be
  # joined into a single skip of a Regexp match.
  class JoinPredicateNestedMatch < Optimization
    include PredicateNestedMatchJoining
    include PredicateMatchSequenceJoining
  end
end
