require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer

  # Sequences of Regexp matches can be joined into a single Regexp match using
  # capturing groups if necessary.
  class JoinMatchCapturingSequence < Optimization
    include MatchJoining

    include Rattler::Parsers
    include Rattler::Compiler::ParserGenerator

    protected

    def _applies_to?(parser, context)
      context.capturing? and
      parser.is_a?(Sequence) and
      not disqualifying_captures?(parser) and
      any_neighbors?(parser) { |child| eligible_child?(child) }
    end

    def eligible_child?(child)
      child.is_a?(Match) or
      (child.is_a?(GroupMatch) and child.num_groups == 1) or
      (child.is_a?(Skip) and child.child.is_a?(Match))
    end

    def disqualifying_captures?(parser)
      parser.any? { |child| child.capturing? and eligible_child?(child) } and
      parser.any? { |child| capture_incompatible?(child) }
    end

    def capture_incompatible?(child)
      (child.capturing? and not eligible_child?(child)) or
      child.semantic?
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

      {:patterns => patterns, :num_groups => num_groups }
    end

    def join_patterns(info)
      info.merge(:pattern => info[:patterns].join)
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
