#
# = rattler/runtime/packrat_parser.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/runtime'

module Rattler::Runtime
  #
  # A +PackratParser+ is a recursive descent parser that memoizes the results
  # of applying nonterminal rules so that each rule method is invoked at most
  # once at a given parse position.
  #
  # @author Jason Arhart
  #
  class PackratParser < RecursiveDescentParser
    
    # Create a new packrat parser to parse +source+.
    #
    # @param (see RecursiveDescentParser#initialize)
    # @option (see RecursiveDescentParser#initialize)
    #
    def initialize(source, options={})
      super
      @result_memo = {}
      @pos_memo = {}
    end
    
    protected
    
    # Apply a rule by dispatching to the method associated with the given rule
    # name, which is named by <tt>"match_#{rule_name}"<tt>, and if the match
    # fails set a parse error. The result of applying the rule is memoized
    # so that the rule method is invoked at most once at a given parse
    # position.
    #
    # @param (see RecursiveDescentParser#apply)
    # @return (see RecursiveDescentParser#apply)
    #
    def apply(rule_name)
      key = [rule_name, @scanner.pos]
      if @result_memo.has_key? key
        result = @result_memo[key]
        @scanner.pos = @pos_memo[key]
      else
        @result_memo[key] = false
        @pos_memo[key] = @scanner.pos
        @result_memo[key] = result = super
        @pos_memo[key] = @scanner.pos
      end
      result
    end
    
  end
end
