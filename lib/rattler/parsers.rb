#
# = rattler/parsers.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler'

module Rattler
  #
  # The +Parsers+ module defines the basic parsers and combinators used to
  # compose more complex parsers.
  #
  # @author Jason Arhart
  #
  module Parsers

    autoload :Parser, 'rattler/parsers/parser'
    autoload :CombinatorParser, 'rattler/parsers/combinator_parser'
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
    autoload :DispatchAction, 'rattler/parsers/dispatch_action'
    autoload :DirectAction, 'rattler/parsers/direct_action'
    autoload :SemanticAssert, 'rattler/parsers/semantic_assert'
    autoload :SemanticDisallow, 'rattler/parsers/semantic_disallow'
    autoload :SideEffect, 'rattler/parsers/side_effect'
    autoload :SemanticAttribute, 'rattler/parsers/semantic_attribute'
    autoload :Semantic, 'rattler/parsers/semantic'
    autoload :Token, 'rattler/parsers/token'
    autoload :Skip, 'rattler/parsers/skip'
    autoload :Label, 'rattler/parsers/label'
    autoload :BackReference, 'rattler/parsers/back_reference'
    autoload :Fail, 'rattler/parsers/fail'
    autoload :ParserDSL, 'rattler/parsers/parser_dsl'
    autoload :Predicate, 'rattler/parsers/predicate'
    autoload :Atomic, 'rattler/parsers/atomic'
    autoload :Combining, 'rattler/parsers/combining'
    autoload :MatchJoining, 'rattler/parsers/match_joining'
    autoload :ParserScope, 'rattler/parsers/parser_scope'
    autoload :ActionCode, 'rattler/parsers/action_code'
    autoload :EffectCode, 'rattler/parsers/effect_code'
    autoload :AssertCode, 'rattler/parsers/assert_code'
    autoload :DisallowCode, 'rattler/parsers/disallow_code'
    autoload :NodeCode, 'rattler/parsers/node_code'

    class <<self
      # Define parse rules with the given block
      #
      # @return [Rules] a set of parse rules
      #
      def define(&block)
        ParserDSL.rules(&block)
      end
    end

  end
end
