require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer
  module PredicateMatchJoining
    include CompositeReducing

    include Rattler::Parsers

    protected

    def reduce(*pair)
      Match[Regexp.new(join_patterns(pair.map { |child| prepare_pattern(child) }))]
    end

    def _apply(parser, context)
      a = []
      parser.each do |child|
        a << (eligible_pair?(a.last, child) ? reduce(a.pop, child) : child)
      end
      finish_reduce(parser, a)
    end

    def any_eligible_pairs?(children)
      children.each_cons(2).any? {|a, b| eligible_pair?(a, b) }
    end

    def eligible_pair?(a, b)
      (eligible_match?(a) and eligible_predicate?(b)) or
      (eligible_predicate?(a) and eligible_match?(b))
    end

    def eligible_match?(parser)
      parser.is_a?(Match)
    end

    def eligible_predicate?(parser)
      case parser
      when Eof
        true
      when Assert, Disallow
        parser.child.is_a?(Match)
      else
        false
      end
    end
  end
end
