require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer

  # An +Optimization+ represents a simple transformation of a parser model into
  # an equivalent model that can result in more efficient parsing code.
  # Subclasses override <tt>#_applies_to?</tt> and <tt>#_apply</tt> to define
  # an optimization.
  class Optimization

    class <<self
      # @return a lazy singleton instance
      def instance
        @instance ||= self.new
      end

      # (see Rattler::Compiler::Optimizer::Optimization#>>)
      def >>(other)
        instance >> (other.respond_to?(:instance) ? other.instance : other)
      end

      # (see Rattler::Compiler::Optimizer::Optimization#apply)
      def apply(*args)
        instance.apply(*args)
      end

      # (see Rattler::Compiler::Optimizer::Optimization#applies_to?)
      def applies_to?(*args)
        instance.applies_to?(*args)
      end
    end

    def initialize
      @applies_to_cache = Hash.new {|h, k| h[k] = {} }
    end

    # Return a new optimzation that sequences this optimzation and +other+,
    # i.e. the new optimzation applies this optimzation, then applies +other+
    # to the result.
    #
    # @param [Rattler::Compiler::Optimizer::Optimization] other the optimization
    #   to apply after this one
    #
    # @return [Rattler::Compiler::Optimizer::Optimization] a new optimzation
    #   that sequences this optimzation and +other+
    def >>(other)
      OptimizationSequence.new(self, other)
    end

    # Apply the optimzation to +parser+ in +context+ if
    # <tt>#applies_to?(parser, context)</tt> is +true+.
    #
    # @param [Rattler::Parsers::Parser] parser the parser to be optimized
    # @param [Rattler::Compiler::Optimizer::OptimizationContext] context
    #
    # @return [Rattler::Parsers::Parser] the optimized parser
    def apply(parser, context)
      applies_to?(parser, context) ? _apply(parser, context) : parser
    end

    # @param [Rattler::Parsers::Parser] parser a parser model
    # @param [Rattler::Compiler::Optimizer::OptimizationContext] context
    #
    # @return +true+ if this optimzation applies to +parser+ in +context+
    def applies_to?(parser, context)
      @applies_to_cache[context].fetch(parser) {
        @applies_to_cache[context][parser] = _applies_to?(parser, context)
      }
    end

  end
end
