#
# = rattler/back_end/optimizer/simplify_redundant_repeat.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler'

module Rattler::BackEnd::Optimizer
  #
  # A repeat of a repeat can be simplified to a simple repeat.
  #
  # @author Jason Arhart
  #
  class SimplifyRedundantRepeat < Optimization

    include Rattler::Parsers

    @@repeat_types = [ZeroOrMore, OneOrMore, Optional]

    protected

    def _applies_to?(parser, context)
      context.matching? and
      [parser, parser.child].all? {|_| repeat? _ }
    end

    def _apply(parser, context)
      if @@repeat_types.any? {|_| parser.is_a?(_) and parser.child.is_a?(_) }
        parser.child
      else
        ZeroOrMore[parser.child.child]
      end
    end

    private

    def repeat?(parser)
      @@repeat_types.any? {|_| parser.is_a? _ }
    end

  end
end
