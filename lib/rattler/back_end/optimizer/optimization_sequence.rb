#
# = rattler/back_end/optimizer/optimization.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler'

module Rattler::BackEnd::Optimizer
  #
  # An +OptimizationSequence+ sequences a pair of optimzations so that applying
  # the sequence applies the first optimization, then applies the second
  # optimzation to the result.
  #
  # @author Jason Arhart
  #
  class OptimizationSequence < Optimization

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
