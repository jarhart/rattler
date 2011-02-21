#
# = rattler/runtime/recursive_descent_parser.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/runtime'

module Rattler::Runtime
  #
  # +RecursiveDescentParser+ is the base class for any recursive descent
  # parsers. It supports unlimited backtracking, which may result in rules
  # being applied to the same source many times. It is usually preferable to
  # use {PackratParser}, which memoizes parse results.
  #
  # @author Jason Arhart
  #
  class RecursiveDescentParser < Parser
    include ParserHelper
    include Rattler::Grammar::GrammarDSL

    # Create a new recursive descent parser to parse +source+.
    #
    # @param (see Parser#initialize)
    # @option (see Parser#initialize)
    #
    def initialize(source, options={})
      super
      @rule_method_names = Hash.new {|h, name| h[name] = :"match_#{name}" }
    end

    # Apply a rule by dispatching to the method associated with +rule_name+
    # which is named by <tt>"match_#{rule_name}"<tt>, and if the match fails
    # register a parse failure.
    #
    # @param (see #apply)
    # @return (see #apply)
    #
    def match(rule_name)
      apply(rule_name) or fail { rule_name }
    end

    def method_missing(symbol, *args)
      (symbol == :start_rule) ? :start : super
    end

    def respond_to?(symbol)
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

    # Apply a rule by dispatching to the method associated with the given rule
    # name, which is named by <tt>"match_#{rule_name}"<tt>. This method is
    # called by +match+ and should not be called directly.
    #
    # @param [Symbol] rule_name the name of the rule to apply
    #
    # @return the result of applying the rule
    #
    def apply(rule_name)
      send @rule_method_names[rule_name]
    end

  end
end
