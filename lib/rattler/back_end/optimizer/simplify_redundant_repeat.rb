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

    protected

    def _applies_to?(parser, context)
      context.matching? and
      [parser, parser.child].all? {|_| simple_repeat? _ }
    end

    def _apply(parser, context)
      if (parser.zero_or_more? and parser.child.zero_or_more?) or
          (parser.one_or_more? and parser.child.one_or_more?) or
          (parser.optional? and parser.child.optional?)
        parser.child
      else
        Repeat[parser.child.child, 0, nil]
      end
    end

    private

    def simple_repeat?(parser)
      parser.is_a? Repeat and
      ( parser.zero_or_more? or
        parser.one_or_more? or
        parser.optional? )
    end

  end
end
