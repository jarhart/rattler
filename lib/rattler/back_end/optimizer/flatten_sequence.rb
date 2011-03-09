#
# = rattler/back_end/optimizer/flatten_sequence.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler'

module Rattler::BackEnd::Optimizer

  #
  # Nested sequence expressions can be flattened without affecting how they
  # match.
  #
  # @author Jason Arhart
  #
  class FlattenMatchingSequence < Optimization
    include Flattening
    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      context.matching? and
      parser.is_a?(Sequence) and
      super
    end

    def eligible_child?(child)
      child.is_a? Sequence
    end
  end

  #
  # Nested sequence expressions can be flattened without affecting how they
  # parse if the nested sequence expressions are not multi-capturing.
  #
  # @author Jason Arhart
  #
  class FlattenCapturingSequence < Optimization
    include Flattening
    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      context.capturing? and
      parser.is_a?(Sequence) and
      super
    end

    def eligible_child?(child)
      child.is_a?(Sequence) and child.capture_count <= 1
    end
  end

  FlattenSequence = FlattenMatchingSequence >> FlattenCapturingSequence

end
