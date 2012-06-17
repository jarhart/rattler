require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer
  # A predicate and an adjacent Regexp match in a Choice can be joined into a
  # single Regexp match.
  JoinPredicateOrMatch = JoinPredicateOrBareMatch >> JoinPredicateOrNestedMatch
end
