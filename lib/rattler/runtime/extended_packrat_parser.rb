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
  # to support left-recursive grammars. It currently only implements the first
  # part to support direct left recursion.
  #
  # @author Jason Arhart
  #
  class ExtendedPackratParser < PackratParser

    private
    
    # @private
    def apply!(rule_name, key, start_pos) #:nodoc:
      lr = LR.new
      m = @memo[key] = MemoEntry.new(lr, start_pos, nil, nil)
      if result = memorize m, eval_rule(rule_name)
        result = grow_lr(rule_name, start_pos, m) if lr.detected
        result
      end
    end

    def recall(m)
      result = super
      if result.is_a? LR
        result.detected = true
        false
      else
        result
      end
    end

    # @private
    def grow_lr(rule_name, start_pos, m) #:nodoc:
      loop do
        @scanner.pos = start_pos
        result = eval_rule(rule_name)
        return recall(m) if !result or @scanner.pos <= m.end_pos
        memorize m, result
      end
    end
    
    # @private
    class LR
      def initialize(detected = false)
        @detected = detected
      end
      attr_accessor :detected
    end

  end

end
