require 'rattler/runtime'

module Rattler::Runtime

  # +ExtendedPackratParser+ implements the algorithm described by Alessandro
  # Warth, James R. Douglass, and Todd Millstein for extending packrat parsing
  # to support left-recursive grammars.
  class ExtendedPackratParser < PackratParser

    # Create a new extended packrat parser to parse +source+.
    #
    # @param (see PackratParser#initialize)
    # @option (see PackratParser#initialize)
    #
    def initialize(source, options={})
      super
      @heads = {}
      @lr_stack = []
    end

    # Apply a rule by dispatching to the given match method. The result of
    # applying the rule is memoized so that the match method is invoked at most
    # once at a given parse position. Left-recursion is detected and parsed
    # correctly.
    #
    # @param (see PackratParser#apply)
    # @return (see PackratParser#apply)
    #
    def apply(match_method_name)
      start_pos = @scanner.pos
      if m = memo_lr(match_method_name, start_pos)
        recall m, match_method_name
      else
        lr = LR.new(false, match_method_name, nil)
        @lr_stack.push lr
        m = inject_memo match_method_name, start_pos, lr, start_pos
        result = eval_rule match_method_name
        @lr_stack.pop
        if lr.head
          m.end_pos = @scanner.pos
          lr.seed = result
          lr_answer match_method_name, start_pos, m
        else
          save m, result
        end
      end
    end

    private

    # @private
    def memo_lr(match_method_name, start_pos) #:nodoc:
      m = memo(match_method_name, start_pos)
      head = @heads[start_pos] or return m
      if !m && !head.involves?(match_method_name)
        return inject_fail match_method_name, start_pos
      end
      if head.eval_set.delete(match_method_name)
        save m, eval_rule(match_method_name)
      end
      return m
    end

    # @private
    def recall(m, match_method_name) #:nodoc:
      if (result = m.result).is_a? LR
        setup_lr match_method_name, result
        result.seed
      else
        super
      end
    end

    # @private
    def setup_lr(match_method_name, lr) #:nodoc:
      lr.head ||= Head.new(match_method_name)
      @lr_stack.reverse_each do |_|
        return if _.head == lr.head
        lr.head.involved_set[_.match_method_name] = _.match_method_name
      end
    end

    # @private
    def lr_answer(match_method_name, start_pos, m) #:nodoc:
      head = m.result.head
      if head.match_method_name == match_method_name
        grow_lr(match_method_name, start_pos, m, head) if m.result = m.result.seed
      else
        save m, m.result.seed
      end
    end

    # @private
    def grow_lr(match_method_name, start_pos, m, head) #:nodoc:
      @heads[start_pos] = head
      loop do
        @scanner.pos = start_pos
        head.eval_set.replace(head.involved_set)
        result = eval_rule(match_method_name)
        if !result or @scanner.pos <= m.end_pos
          @heads.delete(start_pos)
          return recall m, match_method_name
        end
        save m, result
      end
    end

    # @private
    class LR #:nodoc:
      def initialize(seed, match_method_name, head)
        @seed = seed
        @match_method_name = match_method_name
        @head = head
      end
      attr_accessor :seed, :match_method_name, :head
    end

    # @private
    class Head #:nodoc:
      def initialize(match_method_name)
        @match_method_name = match_method_name
        @involved_set = {}
        @eval_set = {}
      end
      attr_accessor :match_method_name, :involved_set, :eval_set
      def involves?(match_method_name)
        match_method_name == self.match_method_name or involved_set.has_key? match_method_name
      end
    end

  end
end
