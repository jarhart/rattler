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
    autoload :Optional, 'rattler/parsers/optional'
    autoload :ZeroOrMore, 'rattler/parsers/zero_or_more'
    autoload :OneOrMore, 'rattler/parsers/one_or_more'
    autoload :Repeat, 'rattler/parsers/repeat'
    autoload :ListParser, 'rattler/parsers/list_parser'
    autoload :Apply, 'rattler/parsers/apply'
    autoload :Assert, 'rattler/parsers/assert'
    autoload :Disallow, 'rattler/parsers/disallow'
    autoload :Eof, 'rattler/parsers/eof'
    autoload :DispatchAction, 'rattler/parsers/dispatch_action'
    autoload :DirectAction, 'rattler/parsers/direct_action'
    autoload :Token, 'rattler/parsers/token'
    autoload :Skip, 'rattler/parsers/skip'
    autoload :Label, 'rattler/parsers/label'
    autoload :BackReference, 'rattler/parsers/back_reference'
    autoload :Fail, 'rattler/parsers/fail'
    autoload :ParserDSL, 'rattler/parsers/parser_dsl'
    autoload :Predicate, 'rattler/parsers/predicate'
    autoload :Combining, 'rattler/parsers/combining'
    autoload :MatchJoining, 'rattler/parsers/match_joining'
    autoload :ActionCode, 'rattler/parsers/action_code'
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
