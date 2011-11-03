#
# = rattler/back_end/optimizer/flatten_choice.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler'

module Rattler::BackEnd::Optimizer
  #
  # Optimizes all of the children of a parser model in the appropriate context.
  #
  # @author Jason Arhart
  #
  class OptimizeChildren < Optimization

    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      !parser.children.empty? and
      (parser.any? do |_|
        optimizations.applies_to? _, child_context(parser, context)
      end)
    end

    def _apply(parser, context)
      parser.with_children(parser.map do |_|
        optimizations.apply _, child_context(parser, context)
      end)
    end

    private

    def child_context(parser, context)
      case parser
      when Assert, Disallow, Token, Skip
        context.with :type => :matching
      else
        context
      end
    end

    def optimizations
      ::Rattler::BackEnd::Optimizer.optimizations
    end

  end
end
