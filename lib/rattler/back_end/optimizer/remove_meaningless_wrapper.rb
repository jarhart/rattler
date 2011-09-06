#
# = rattler/back_end/optimizer/remove_meaningless_wrapper.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler'

module Rattler::BackEnd::Optimizer
  #
  # Token and skip wrappers only have meaning in a capturing context.
  #
  # @author Jason Arhart
  #
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
