require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer
  module PredicateBareMatchJoining
    include PredicateMatchJoining

    protected

    def prepare_pattern(child)
      prepare_bare_pattern(child)
    end

    def eligible_match?(parser)
      parser.is_a?(Match)
    end

  end
end
