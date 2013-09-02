require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer

  # A predicate and an adjacent Regexp match in a Sequence can be joined into a
  # single Regexp match.
  class JoinPredicateBareMatch < Optimization
    include PredicateBareMatchJoining
    include PredicateMatchSequenceJoining
  end
end
