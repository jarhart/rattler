require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer

  # A token wrapping a terminal parser is redundant.
  class SimplifyTokenMatch < Optimization

    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      parser.is_a?(Token) and
      terminal?(parser.child)
    end

    def _apply(parser, context)
      parser.child
    end

    def terminal?(parser)
      case parser
      when Match, Token, BackReference then true
      else false
      end
    end

  end
end
