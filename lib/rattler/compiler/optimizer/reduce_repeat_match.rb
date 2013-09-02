require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer

  # A repeat of a Regexp match can be reduced to a single Regexp match.
  class ReduceRepeatMatch < Optimization

    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      context.matching? and
      parser.is_a?(Repeat) and
      parser.child.is_a?(Match)
    end

    def _apply(parser, context)
      Match[Regexp.new("(?>#{parser.child.re.source})#{suffix parser}")]
    end

    private

    def suffix(parser)
      if parser.zero_or_more?
        '*'
      elsif parser.one_or_more?
        '+'
      elsif parser.optional?
        '?'
      else
        general_suffix(parser.lower_bound, parser.upper_bound)
      end
    end

    def general_suffix(lower_bound, upper_bound)
      if lower_bound == upper_bound
        "{#{lower_bound}}"
      elsif !upper_bound
        "{#{lower_bound},}"
      else
        "{#{lower_bound},#{upper_bound}}"
      end
    end

  end
end
