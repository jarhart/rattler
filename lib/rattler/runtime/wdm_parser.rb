#
# = rattler/runtime/recursive_descent_parser.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/runtime'

module Rattler::Runtime
  #
  # +WDMParser+ implements the algorithm described by Alessandro Warth,
  # James R. Douglass, and Todd Millstein for extending packrat parsing to
  # support left-recursive grammars. It currently only implements the first
  # part to support direct left recursion.
  #
  # @author Jason Arhart
  #
  class WDMParser < RecursiveDescentParser
    
    # Create a new packrat parser to parse +source+.
    #
    # @param (see RecursiveDescentParser#initialize)
    # @option (see RecursiveDescentParser#initialize)
    #
    def initialize(*args)
      super
      @memo = {}
    end
    
    # @private
    alias_method :eval_rule, :apply
    private :eval_rule
    
    protected
    
    # Apply a rule by dispatching to the method associated with the given rule
    # name, which is named by <tt>"match_#{rule_name}"<tt>, and if the match
    # fails set a parse error. The result of applying the rule is memoized so
    # that the rule method is invoked at most once at a given parse position.
    #
    # @param (see RecursiveDescentParser#apply)
    # @return (see RecursiveDescentParser#apply)
    #
    def apply(rule_name)
      p = @scanner.pos
      key = [rule_name, p]
      if memo = @memo[key]
        if memo.size == 1
          memo[0] = true
          false
        else
          @scanner.pos = memo[1]
          memo[0]
        end
      else
        lr = @memo[key] = [false]
        result = eval_rule(rule_name)
        memo = @memo[key]
        memo[0] = result
        memo[1] = @scanner.pos
        result = grow_lr(rule_name, p, memo) if result and lr[0]
        result
      end
    end
    
    private
    
    def grow_lr(rule_name, p, memo)
      loop do
        @scanner.pos = p
        result = eval_rule(rule_name)
        if !result or @scanner.pos <= memo[1]
          @scanner.pos = memo[1]
          return memo[0]
        end
        memo[0] = result
        memo[1] = @scanner.pos
      end
    end
    
  end
end
