require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer

  # Token and skip wrappers only have meaning in a capturing context.
  class RemoveMeaninglessWrapper < Optimization

    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      context.matching? and
      [Token, Skip].any? {|_| parser.is_a? _ }
    end

    def _apply(parser, context)
      parser.child
    end

  end
end
