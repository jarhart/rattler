require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer

  # Sequences of Regexp matches can be joined into a single Regexp without
  # affecting how they match.
  class JoinMatchMatchingSequence < Optimization
    include MatchJoining

    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      context.matching? and
      parser.is_a?(Sequence) and
      any_neighbors?(parser) {|_| eligible_child? _ }
    end

    def eligible_child?(child)
      child.is_a? Match
    end

    def create_pattern(match)
      "(?>#{match.re.source})"
    end

  end
end
