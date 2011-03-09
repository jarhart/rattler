require 'rattler'

module Rattler::BackEnd::Optimizer
  # @private
  module Flattening #:nodoc:

    def _applies_to?(parser, context)
      parser.any? {|_| eligible_child? _ }
    end

    def _apply(parser, context)
      children = parser.map {|_| eligible_child?(_) ? _.to_a : [_] }.reduce(:+)
      parser.class.new(children, parser.attrs)
    end

  end
end
