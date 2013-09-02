require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer
  # @private
  module Flattening #:nodoc:

    def _applies_to?(parser, context)
      parser.any? { |child| eligible_child?(child) }
    end

    def _apply(parser, context)
      parser.flat_map_children { |c| eligible_child?(c) ? c.to_a : [c] }
    end

  end
end
