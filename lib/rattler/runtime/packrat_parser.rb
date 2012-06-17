require 'rattler/runtime'

module Rattler::Runtime

  # A +PackratParser+ is a recursive descent parser that memoizes the results
  # of applying nonterminal rules so that each rule method is invoked at most
  # once at a given parse position.
  class PackratParser < RecursiveDescentParser

    # Create a new packrat parser to parse +source+.
    #
    # @param (see RecursiveDescentParser#initialize)
    # @option (see RecursiveDescentParser#initialize)
    #
    def initialize(source, options={})
      super
      @memo = Hash.new {|h, match_method_name| h[match_method_name] = {} }
    end

    protected

    # Apply a rule by dispatching to the given match method. The result of
    # applying the rule is memoized so that the match method is invoked at most
    # once at a given parse position.
    #
    # @param (see RecursiveDescentParser#apply)
    # @return (see RecursiveDescentParser#apply)
    #
    def apply(match_method_name)
      start_pos = @scanner.pos
      if m = memo(match_method_name, start_pos)
        recall m, match_method_name
      else
        m = inject_fail match_method_name, start_pos
        save m, eval_rule(match_method_name)
      end
    end

    alias_method :eval_rule, :send

    private

    # @private
    def memo(match_method_name, start_pos) #:nodoc:
      @memo[match_method_name][start_pos]
    end

    # @private
    def inject_memo(match_method_name, start_pos, result, end_pos) #:nodoc:
      @memo[match_method_name][start_pos] = MemoEntry.new(result, end_pos)
    end

    # @private
    def inject_fail(match_method_name, fail_pos) #:nodoc:
      @memo[match_method_name][fail_pos] = MemoEntry.new(false, fail_pos)
    end

    # @private
    def save(m, result) #:nodoc:
      m.end_pos = @scanner.pos
      m.result = result
    end

    # @private
    def recall(m, match_method_name) #:nodoc:
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
