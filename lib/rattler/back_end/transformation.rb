require 'rattler'

module Rattler::BackEnd
  #
  # A +Transformation+ represents a simple transformation of a parser model
  # into a different model. Subclasses override <tt>#_applies_to?</tt> and
  # <tt>#_apply</tt> to define a transformation.
  #
  # @author Jason Arhart
  #
  class Transformation

    class <<self
      def instance
        @instance ||= self.new
      end

      # @see Rattler::BackEnd::Transformation#>>
      def >>(other)
        instance >> (other.respond_to?(:instance) ? other.instance : other)
      end

      # @see Rattler::BackEnd::Transformation#match
      def apply(*args)
        instance.apply(*args)
      end

      # @see Rattler::BackEnd::Transformation#applies_to?
      def applies_to?(*args)
        instance.applies_to?(*args)
      end
    end

    def initialize
      @applies_to_cache = Hash.new {|h, k| h[k] = {} }
    end

    # Return a new transformation that sequences this optimzation and +other+,
    # i.e. the new transformation applies this transformation, then applies
    # +other+ to the result.
    #
    # @param [Rattler::BackEnd::Transformation] other the transformation to
    #   apply after this one
    #
    # @return [Rattler::BackEnd::Transformation] a new transformation that
    #   sequences this transformation and then +other+
    def >>(other)
      TransformationSequence.new(self, other)
    end

    # Apply the transformation to +parser+ in +context+ if
    # <tt>self.applies_to?(parser, context)</tt> is +true+.
    #
    # @param [Rattler::Parsers::Parser] parser the parser to be transformed
    # @param [Rattler::BackEnd::Transformation] context
    #
    # @return [Rattler::Parsers::Parser] the transformed parser
    def apply(parser, context)
      applies_to?(parser, context) ? _apply(parser, context) : parser
    end

    # Return +true+ if this transformation applies to +parser+ in +context+.
    #
    # @param [Rattler::Parsers::Parser] parser a parser model
    # @param [Rattler::BackEnd::Transformation] context
    #
    # @return [Boolean] +true+ if this transformation applies to +parser+ in
    #   +context+
    def applies_to?(parser, context)
      @applies_to_cache[context].fetch(parser) do
        @applies_to_cache[context][parser] = _applies_to?(parser, context)
      end
    end

  end
end
