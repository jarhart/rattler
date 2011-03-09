#
# = rattler/back_end/optimizer/flatten_choice.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler'

module Rattler::BackEnd::Optimizer
  #
  # Nested choice expressions can be flattened without affecting how they parse.
  #
  # @author Jason Arhart
  #
  class FlattenChoice < Optimization
    include Flattening

    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      parser.is_a?(Choice) and super
    end

    def eligible_child?(child)
      child.is_a? Choice
    end

  end
end
