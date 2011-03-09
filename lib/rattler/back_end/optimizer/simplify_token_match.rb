#
# = rattler/back_end/optimizer/simplify_token_match.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler'

module Rattler::BackEnd::Optimizer
  #
  # A token of a match is equivalent to the match by itself.
  #
  # @author Jason Arhart
  #
  class SimplifyTokenMatch < Optimization

    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      parser.is_a?(Token) and parser.child.is_a?(Match)
    end

    def _apply(parser, context)
      parser.child
    end

  end
end
