require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer

  # A predicate and an adjacent skip of a Regexp match in a Choice can be
  # joined into a single skip of a Regexp match.
  class JoinPredicateOrNestedMatch < Optimization
    include PredicateNestedMatchJoining
    include PredicateMatchChoiceJoining
  end
end
