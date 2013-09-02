require 'rattler/parsers'

module Rattler::Parsers

  # +RuleSet+ encapsulates a set of parse rules that define a grammar and
  # provides accessors to the rules by name.
  class RuleSet < Rattler::Util::Node

    # @private
    def self.parsed(results, *_) #:nodoc:
      self.new(results[0])
    end

    # Create a +RuleSet+ instance.
    #
    # @overload initialize()
    #   @return [RuleSet]
    # @overload initialize(rule...)
    #   @return [RuleSet]
    # @overload initialize(attribute...)
    #   @return [RuleSet]
    # @overload initialize(rule..., attribute...)
    #   @return [RuleSet]
    def initialize(*args)
      super
      @by_name = {}
      children.each {|rule| @by_name[rule.name] = rule }
    end

    alias_method :rules, :children

    # @return [Symbol] the name of the rule to start parsing with
    def start_rule
      attrs[:start_rule]
    end

    # @param [Symbol] name the name of a rule in the rule set
    # @return [Rule] the rule with the given name in the rule set
    def rule(name)
      @by_name[name] || inherited_rule(name)
    end

    # @param [Symbol] name the name of a rule in an inherited rule set
    # @return [Rule] the rule with the given name in the inherited rule set
    def inherited_rule(name)
      includes.inject(nil) {|r,s| r || s.rule(name) }
    end

    # @return [Array<String>] a list of modules to be included in the parser
    def includes
      attrs[:includes] || []
    end

    # Access the rule set's rules
    #
    # @overload [](rule_name)
    #   @param [Symbol] name the name of a rule in the rule set
    #   @return [Rule] the rule with the given name in the rule set
    # @overload [](index)
    #   @param [Integer] index index of the rule
    #   @return the rule at +index+
    # @overload [](start, length)
    #   @param [Integer] start the index of the first rule
    #   @param [Integer] length the number of rules to return
    #   @return [Array] the rules starting at +start+ and continuing for
    #     +length+ rules
    # @overload [](range)
    #   @param [Range] range the range of rules
    #   @return [Array] the rules specified by +range+
    def [](*args)
      if args.length == 1 and args[0].is_a?(Symbol)
        rule(args[0])
      else
        super
      end
    end

    alias_method :with_rules, :with_children
    alias_method :map_rules, :map_children

    # @yield Run the block as a predicate once for each rule
    # @yieldparam [Rule] rule one rule in the rule set
    # @yieldreturn [Boolean] +true+ to include the rule in the new rule set
    # @return [RuleSet] a new rule set with the rules for which the block
    #   returns +true+
    def select_rules
      self.with_rules(rules.select {|rule| yield rule })
    end

    # @return [Analysis] a static analysis of the rules
    def analysis
      @analysis ||= Analysis.new(self)
    end

  end
end
