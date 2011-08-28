#
# = rattler/back_end/optimizer/join_match_capturing_sequence.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler'

module Rattler::BackEnd::Optimizer
  #
  # Sequences of Regexp matches can be joined into a single Regexp match using
  # capturing groups if necessary.
  #
  # @author Jason Arhart
  #
  class JoinMatchCapturingSequence < Optimization
    include MatchJoining

    include Rattler::Parsers
    include Rattler::BackEnd::ParserGenerator

    protected

    def _applies_to?(parser, context)
      context.capturing? and
      parser.is_a?(Sequence) and
      not disqualifying_captures?(parser) and
      any_neighbors?(parser) {|_| eligible_child? _ }
    end

    def disqualifying_captures?(parser)
      capturing_children = parser.select {|_| _.capturing? }
      capturing_children.any? {|_| eligible_child? _ } and
      capturing_children.any? {|_| not eligible_child? _ }
    end

    def eligible_child?(child)
      child.is_a? Match or
      (child.is_a? GroupMatch and child.num_groups == 1) or
      (child.is_a? Skip and child.child.is_a? Match)
    end

    def create_patterns(parsers)
      num_groups = 0
      patterns = parsers.map do |parser|
        case parser

        when Match
          num_groups += 1
          "(#{parser.re.source})"

        when GroupMatch
          num_groups += parser.num_groups
          "(?>#{parser.re.source})"

        when Skip
          "(?>#{parser.child.re.source})"

        end
      end
      return {:patterns => patterns, :num_groups => num_groups }
    end

    def join_patterns(info)
      return info.merge(:pattern => info[:patterns].join)
    end

    def create_match(info)
      match = super(info[:pattern])
      if info[:num_groups] > 0
        GroupMatch[match, {:num_groups => info[:num_groups]}]
      else
        Skip[match]
      end
    end

  end
end
