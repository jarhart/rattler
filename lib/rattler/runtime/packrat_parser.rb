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
      @memo = {}
    end
    
    # @private
    alias_method :eval_rule, :apply
    private :eval_rule
    
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
      start_pos = @scanner.pos
      key = [rule_name, start_pos]
      if m = memo(key, rule_name, start_pos)
        recall m, rule_name
      else
        apply! rule_name, key, start_pos
      end
    end

    private

    # @private
    def apply!(rule_name, key, start_pos) #:nodoc:
      m = inject_memo key, false, start_pos, start_pos, 'left-recursion detected'
      memorize m, eval_rule(rule_name)
    end

    def memo(key, rule_name, start_pos)
      @memo[key]
    end

    def inject_memo(key, result, end_pos, failure_pos, failure_msg)
      @memo[key] = MemoEntry.new(result, end_pos, failure_pos, failure_msg)
    end

    # @private
    def memorize(m, result) #:nodoc:
      m.end_pos = @scanner.pos
      m.failure_pos = @failure_pos
      m.failure_msg = @failure_msg
      m.result = result
    end

    # @private
    def recall(m, rule_name) #:nodoc:
      @scanner.pos = m.end_pos
      @failure_pos = m.failure_pos
      @failure_msg = m.failure_msg
      m.result
    end

    # @private
    class MemoEntry #:nodoc:
      def initialize(result, end_pos, failure_pos, failure_msg)
        @result = result
        @end_pos = end_pos
        @failure_pos = failure_pos
        @failure_msg = failure_msg
      end
      attr_accessor :result, :end_pos, :failure_pos, :failure_msg
    end

  end
end
