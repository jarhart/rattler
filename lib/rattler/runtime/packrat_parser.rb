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
      @memo = Hash.new {|h, rule_name| h[rule_name] = {} }
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
      start_pos = @scanner.pos
      if m = memo(rule_name, start_pos)
        recall m, rule_name
      else
        m = inject_fail rule_name, start_pos
        save m, eval_rule(rule_name)
      end
    end

    alias_method :memoize, :apply

    alias_method :eval_rule, :send

    private

    # @private
    def memo(rule_name, start_pos) #:nodoc:
      @memo[rule_name][start_pos]
    end

    # @private
    def inject_memo(rule_name, start_pos, result, end_pos) #:nodoc:
      @memo[rule_name][start_pos] = MemoEntry.new(result, end_pos)
    end

    # @private
    def inject_fail(rule_name, fail_pos) #:nodoc:
      @memo[rule_name][fail_pos] = MemoEntry.new(false, fail_pos)
    end

    # @private
    def save(m, result) #:nodoc:
      m.end_pos = @scanner.pos
      m.result = result
    end

    # @private
    def recall(m, rule_name) #:nodoc:
      @scanner.pos = m.end_pos
      m.result
    end

    # @private
    class MemoEntry #:nodoc:
      def initialize(result, end_pos)
        @result = result
        @end_pos = end_pos
      end
      attr_accessor :result, :end_pos
    end

  end
end
