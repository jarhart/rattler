#
# = rattler/back_end/optimizer/normalize_repeat.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler'

module Rattler::BackEnd::Optimizer
  #
  # A Repeat with bounds equivalent to optional, zero-or-more, or one-or-more
  # can be replaced by an Optional, a ZeroOrMore, or a OneOrMore, respectively.
  #
  # @author Jason Arhart
  #
  class SpecializeRepeat < Optimization

    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      parser.is_a? Repeat and
      ( parser.optional? or
        parser.zero_or_more? or
        parser.one_or_more? )
    end

    def _apply(parser, context)
      if parser.optional?
        Optional[parser.child]
      elsif parser.zero_or_more?
        ZeroOrMore[parser.child]
      elsif parser.one_or_more?
        OneOrMore[parser.child]
      end
    end

  end
end
