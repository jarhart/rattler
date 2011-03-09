#
# = rattler/back_end/optimizer/reduce_repeat_match.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler'

module Rattler::BackEnd::Optimizer
  #
  # A repeat of a Regexp match can be reduced to a single Regexp match.
  #
  # @author Jason Arhart
  #
  class ReduceRepeatMatch < Optimization

    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      context.matching? and
      case parser
      when ZeroOrMore, OneOrMore, Optional
        parser.child.is_a?(Match)
      end
    end

    def _apply(parser, context)
      Match[Regexp.new("(?>#{parser.child.re.source})#{suffix parser}")]
    end

    private

    def suffix(parser)
      case parser
      when ZeroOrMore then '*'
      when OneOrMore then '+'
      when Optional then '?'
      end
    end

  end
end
