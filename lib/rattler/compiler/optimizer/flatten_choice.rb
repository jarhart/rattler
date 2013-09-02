require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer

  # Nested choice expressions can be flattened without affecting how they parse.
  class FlattenChoice < Optimization
    include Flattening

    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      parser.is_a?(Choice) and super
    end

    def eligible_child?(child)
      child.is_a?(Choice)
    end

  end
end
