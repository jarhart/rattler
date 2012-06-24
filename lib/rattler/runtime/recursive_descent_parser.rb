require 'rattler/runtime'

module Rattler::Runtime

  # +RecursiveDescentParser+ is the base class for any recursive descent
  # parsers. It supports unlimited backtracking, which may result in rules
  # being applied to the same source many times. It is usually preferable to
  # use {PackratParser}, which memoizes parse results.
  class RecursiveDescentParser < Parser
    include ParserHelper

    class <<self
      private
      def grammar(source)
        Rattler.compile(self, source)
      end
    end

    # Create a new recursive descent parser to parse +source+.
    #
    # @param (see Parser#initialize)
    # @option (see Parser#initialize)
    #
    def initialize(source, options={})
      super
      @rule_method_names = Hash.new {|h, name| h[name] = :"match_#{name}" }
    end

    # Attempt to match the source by applying the named parse rule and return
    # the result. If the rule is successfully matched the result is "thruthy".
    # If the rules captures parse results, the captured results are returned,
    # otherwise the result is +true+. If the rule fails to match, the result
    # may be +false+ or +nil+.
    #
    # @param [Symbol] rule_name the name of the parse rule.
    # @return the result of applying the parse rule.
    def match(rule_name)
      send @rule_method_names[rule_name]
    end

    # @private
    def method_missing(symbol, *args) #:nodoc:
      (symbol == :start_rule) ? :start : super
    end

    # @private
    def respond_to?(symbol) #:nodoc:
      super or (symbol == :start_rule)
    end

    protected

    # Parse by matching the rule returned by <tt>#start_rule</tt> or
    # <tt>:start</tt> if <tt>#start_rule</tt> is not defined.
    #
    # @return the result of applying the start rule
    def __parse__
      match start_rule
    end

    # Apply a rule by directly dispatching to the given match method.
    #
    # @param [Symbol] match_method_name the name of the match method.
    # @return the result of applying the parse rule.
    def apply(match_method_name)
      send match_method_name
    end

  end
end
