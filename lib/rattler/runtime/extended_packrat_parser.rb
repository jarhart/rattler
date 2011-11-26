#
# = rattler/runtime/extended_packrat_parser.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/runtime'

module Rattler::Runtime
  #
  # +ExtendedPackratParser+ implements the algorithm described by Alessandro
  # Warth, James R. Douglass, and Todd Millstein for extending packrat parsing
  # to support left-recursive grammars.
  #
  # @author Jason Arhart
  #
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

    def apply(rule_name)
      start_pos = @scanner.pos
      if m = memo_lr(rule_name, start_pos)
        recall m, rule_name
      else
        lr = LR.new(false, rule_name, nil)
        @lr_stack.push lr
        m = inject_memo rule_name, start_pos, lr, start_pos
        result = eval_rule rule_name
        @lr_stack.pop
        if lr.head
          m.end_pos = @scanner.pos
          lr.seed = result
          lr_answer rule_name, start_pos, m
        else
          save m, result
        end
      end
    end

    private

    # @private
    def memo_lr(rule_name, start_pos) #:nodoc:
      m = memo(rule_name, start_pos)
      head = @heads[start_pos] or return m
      if !m && !head.involves?(rule_name)
        return inject_fail rule_name, start_pos
      end
      if head.eval_set.delete(rule_name)
        save m, eval_rule(rule_name)
      end
      return m
    end

    # @private
    def recall(m, rule_name) #:nodoc:
      if (result = m.result).is_a? LR
        setup_lr rule_name, result
        result.seed
      else
        super
      end
    end

    # @private
    def setup_lr(rule_name, lr) #:nodoc:
      lr.head ||= Head.new(rule_name)
      @lr_stack.reverse_each do |_|
        return if _.head == lr.head
        lr.head.involved_set[_.rule_name] = _.rule_name
      end
    end

    # @private
    def lr_answer(rule_name, start_pos, m) #:nodoc:
      head = m.result.head
      if head.rule_name == rule_name
        grow_lr(rule_name, start_pos, m, head) if m.result = m.result.seed
      else
        save m, m.result.seed
      end
    end

    # @private
    def grow_lr(rule_name, start_pos, m, head) #:nodoc:
      @heads[start_pos] = head
      loop do
        @scanner.pos = start_pos
        head.eval_set.replace(head.involved_set)
        result = eval_rule(rule_name)
        if !result or @scanner.pos <= m.end_pos
          @heads.delete(start_pos)
          return recall m, rule_name
        end
        save m, result
      end
    end

    # @private
    class LR #:nodoc:
      def initialize(seed, rule_name, head)
        @seed = seed
        @rule_name = rule_name
        @head = head
      end
      attr_accessor :seed, :rule_name, :head
    end

    # @private
    class Head #:nodoc:
      def initialize(rule_name)
        @rule_name = rule_name
        @involved_set = {}
        @eval_set = {}
      end
      attr_accessor :rule_name, :involved_set, :eval_set
      def involves?(rule_name)
        rule_name == self.rule_name or involved_set.has_key? rule_name
      end
    end

  end
end
