require 'rattler'

module Rattler::BackEnd::Optimizer
  # @private
  module MatchJoining #:nodoc:

    include CompositeReducing

    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      any_neighbors?(parser) {|_| eligible_child? _ }
    end

    def _apply(parser, context)
      new_children = []
      matches = []
      for child in parser
        if eligible_child? child
          matches << child
        else
          join_matches(matches) {|match| new_children << match }
          matches = []
          new_children << child
        end
      end
      join_matches(matches) {|match| new_children << match }
      finish_reduce parser, new_children
    end

    def any_neighbors?(parser)
      parser.each_cons(2).any? {|a| a.all? {|_| yield _ } }
    end

    def join_matches(matches)
      unless matches.empty?
        yield create_match(join_patterns(create_patterns(matches)))
      end
    end

    def create_patterns(matches)
      matches.map {|_| create_pattern _ }
    end

    def join_patterns(patterns)
      patterns.join
    end

    def create_pattern(match)
      match.re.source
    end

    def create_match(pattern)
      Match[Regexp.new(pattern)]
    end

  end
end
