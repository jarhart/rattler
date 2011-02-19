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
    end

    private
    
    # @private
    def apply!(rule_name, key, start_pos) #:nodoc:
      @lr_stack = lr = LR.new(false, rule_name, nil, @lr_stack)
      m = inject_memo key, lr, start_pos, nil, nil
      result = eval_rule rule_name
      @lr_stack = @lr_stack.tail
      m.end_pos = @scanner.pos
      if lr.head
        lr.seed = result
        lr_answer(rule_name, start_pos, m)
      else
        m.result = result
        result
      end
    end

    # @private
    def memo(key, rule_name, start_pos) #:nodoc:
      m = super
      head = @heads[start_pos] or return m
      if !(m || (rule_name == head.head) || (head.involved_set.has_key? rule_name))
        return inject_memo key, false, start_pos, nil, nil
      end
      if head.eval_set.has_key? rule_name
        head.eval_set.delete(rule_name)
        memorize m, eval_rule(rule_name)
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
      s = @lr_stack
      while s.head != lr.head
        s.head = lr.head
        lr.head.involved_set[s.rule_name] = s.rule_name
        s = s.tail
      end
    end

    # @private
    def lr_answer(rule_name, start_pos, m) #:nodoc:
      head = m.result.head
      if head.rule_name != rule_name
        m.result.seed
      else
        grow_lr(rule_name, start_pos, m, head) if m.result = m.result.seed
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
        memorize m, result
      end
    end

    # @private
    class LR #:nodoc:
      def initialize(seed, rule_name, head, tail)
        @seed = seed
        @rule_name = rule_name
        @head = head
        @tail = tail
      end
      attr_accessor :seed, :rule_name, :head, :tail
    end

    # @private
    class Head #:nodoc:
      def initialize(rule_name)
        @rule_name = rule_name
        @involved_set = {}
        @eval_set = {}
      end
      attr_accessor :rule_name, :involved_set, :eval_set
    end

  end
end
