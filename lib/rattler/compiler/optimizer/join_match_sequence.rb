#
# = rattler/compiler/optimizer/join_match_sequence.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer
  #
  # Sequences of Regexp matches can be joined into a single Regexp match using
  # capturing groups if necessary.
  #
  # @author Jason Arhart
  #
  JoinMatchSequence = JoinMatchMatchingSequence >> JoinMatchCapturingSequence
end
