require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer

  # A predicate and an adjacent Regexp match in a Sequence can be joined into a
  # single Regexp match.
  class JoinPredicateBareMatch < Optimization
    include CompositeReducing

    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      parser.is_a?(Sequence) and
      parser.children.each_cons(2).any? {|a, b| eligible_pair? a, b }
    end

    def _apply(parser, context)
      a = []
      parser.each {|_| a << (eligible_pair?(a.last, _) ? reduce(a.pop, _) : _)}
      finish_reduce parser, a
    end

    def reduce(*pair)
      Match[Regexp.new(pair.map {|_| prepare_pattern _ }.join)]
    end

    def prepare_pattern(child)
      case child
      when Match        then "(?>#{child.re.source})"
      when Assert       then "(?=#{child.child.re.source})"
      when Disallow     then "(?!#{child.child.re.source})"
      when Eof          then "\\z"
      end
    end

    def eligible_pair?(a, b)
      (eligible_match? a and eligible_predicate? b) or
      (eligible_predicate? a and eligible_match? b)
    end

    def eligible_match?(parser)
      parser.is_a? Match
    end

    def eligible_predicate?(parser)
      case parser
      when Eof
        true
      when Assert, Disallow
        parser.child.is_a? Match
      else
        false
      end
    end

  end
end
