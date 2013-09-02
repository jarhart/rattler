require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer
  module PredicateNestedMatchJoining
    include PredicateMatchJoining

    include Rattler::Parsers

    protected

    def reduce(*pair)
      pair.find { |parser| parser.is_a?(Skip) }.with_child(super)
    end

    def prepare_pattern(child)
      prepare_bare_pattern(child.is_a?(Skip) ? child.child : child)
    end

    def eligible_match?(parser)
      parser.is_a?(Skip) and
      parser.child.is_a?(Match)
    end

  end
end
