require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer

  # An +OptimizationSequence+ sequences a pair of optimzations so that applying
  # the sequence applies the second optimzation to the result of applying the
  # first optimzation.
  class OptimizationSequence < Optimization

    include Rattler::Parsers

    def initialize(init, last)
      super()
      @init = init
      @last = last
    end

    # Apply the optimzations to +parser+'s children, then to +parser+, in
    # +context+.
    #
    # @param [Rattler::Parsers::Parser] parser the parser to be optimized
    # @param [Rattler::Compiler::Optimizer::OptimizationContext] context
    #
    # @return [Rattler::Parsers::Parser] the optimized parser
    def deep_apply(parser, context)
      parser = apply(parser, context)
      apply(parser.map_children { |child|
        deep_apply(child, child_context(parser, context))
      }, context)
    end

    protected

    def _applies_to?(parser, context)
      @last.applies_to? parser, context or
      @init.applies_to? parser, context
    end

    def _apply(parser, context)
      @last.apply(@init.apply(parser, context), context)
    end

    private

    def child_context(parser, context)
      case parser
      when Assert, Disallow, Token, Skip
        context.with(:type => :matching)
      else
        context
      end
    end
  end
end
