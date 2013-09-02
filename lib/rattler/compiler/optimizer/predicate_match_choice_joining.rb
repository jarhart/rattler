require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer
  module PredicateMatchChoiceJoining
    include PredicateMatchJoining

    include Rattler::Parsers

    protected

    def _applies_to?(parser, context)
      parser.is_a?(Choice) and
      any_eligible_pairs?(parser.children)
    end

    def join_patterns(patterns)
      patterns.join('|')
    end

    def prepare_bare_pattern(child)
      case child
      when Match    then child.re.source
      when Assert   then "(?=#{child.child.re.source})"
      when Disallow then "(?!#{child.child.re.source})"
      when Eof      then "\\z"
      end
    end
  end
end