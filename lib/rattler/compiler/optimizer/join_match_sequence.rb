require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer
  # Sequences of Regexp matches can be joined into a single Regexp match using
  # capturing groups if necessary.
  JoinMatchSequence = JoinMatchMatchingSequence >> JoinMatchCapturingSequence
end
