#
# = rattler/back_end/optimizer/join_predicate_match.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/back_end/optimizer'

module Rattler::BackEnd::Optimizer
  #
  # A predicate and an adjacent Regexp match in a Sequence can be joined into a
  # single Regexp match.
  #
  # @author Jason Arhart
  #
  JoinPredicateMatch = JoinPredicateBareMatch >> JoinPredicateNestedMatch
end
