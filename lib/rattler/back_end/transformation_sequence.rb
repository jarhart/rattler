require 'rattler'

module Rattler::BackEnd
  #
  # An +TransformationSequence+ is a transformation that sequences a pair of
  # transformations so that applying the sequence applies the first
  # transformation, then applies the second transformation to the result.
  #
  # @author Jason Arhart
  #
  class TransformationSequence < Transformation

    def initialize(init, last)
      super()
      @init = init
      @last = last
    end

    protected

    def _applies_to?(parser, context)
      @last.applies_to? parser, context or
      @init.applies_to? parser, context
    end

    def _apply(parser, context)
      @last.apply(@init.apply(parser, context), context)
    end

  end
end
