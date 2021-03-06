require 'rattler'

module Rattler

  # The +Parsers+ module defines the basic parsers and combinators used to
  # compose recursive descent parsers.
  module Parsers
    autoload :Parser, 'rattler/parsers/parser'
    autoload :CombinatorParser, 'rattler/parsers/combinator_parser'
    autoload :Grammar, 'rattler/parsers/grammar'
    autoload :RuleSet, 'rattler/parsers/rule_set'
    autoload :Rule, 'rattler/parsers/rule'
    autoload :Match, 'rattler/parsers/match'
    autoload :Choice, 'rattler/parsers/choice'
    autoload :Sequence, 'rattler/parsers/sequence'
    autoload :Repeat, 'rattler/parsers/repeat'
    autoload :ListParser, 'rattler/parsers/list_parser'
    autoload :Apply, 'rattler/parsers/apply'
    autoload :Assert, 'rattler/parsers/assert'
    autoload :Disallow, 'rattler/parsers/disallow'
    autoload :Eof, 'rattler/parsers/eof'
    autoload :ESymbol, 'rattler/parsers/e_symbol'
    autoload :SemanticAction, 'rattler/parsers/semantic_action'
    autoload :NodeAction, 'rattler/parsers/node_action'
    autoload :Semantic, 'rattler/parsers/semantic'
    autoload :AttributedSequence, 'rattler/parsers/attributed_sequence'
    autoload :Token, 'rattler/parsers/token'
    autoload :Skip, 'rattler/parsers/skip'
    autoload :Super, 'rattler/parsers/super'
    autoload :Label, 'rattler/parsers/label'
    autoload :BackReference, 'rattler/parsers/back_reference'
    autoload :Fail, 'rattler/parsers/fail'
    autoload :Predicate, 'rattler/parsers/predicate'
    autoload :Atomic, 'rattler/parsers/atomic'
    autoload :Combining, 'rattler/parsers/combining'
    autoload :Sequencing, 'rattler/parsers/sequencing'
    autoload :ParserScope, 'rattler/parsers/parser_scope'
    autoload :ActionCode, 'rattler/parsers/action_code'
    autoload :NodeCode, 'rattler/parsers/node_code'
    autoload :Analysis, 'rattler/parsers/analysis'
  end

end
