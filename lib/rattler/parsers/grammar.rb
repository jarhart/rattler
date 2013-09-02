require 'rattler/parsers'

module Rattler::Parsers

  # +Grammar+ represents a parsed grammar
  class Grammar < Rattler::Util::Node

    # The name of the default parser base class
    DEFAULT_PARSER_BASE = 'Rattler::Runtime::PackratParser'

    @@default_opts = {
      :grammar_name => nil,
      :parser_name => nil,
      :base_name => DEFAULT_PARSER_BASE,
      :requires => [],
      :includes => []
    }

    # @private
    def self.parsed(results, *_) #:nodoc:
      options, rules = results
      self.new(rules, options)
    end

    # @param rules [RuleSet] the parse rules that define the parser
    #
    # @option opts [String] start_rule (rules.first.name)
    # @option opts [String] grammar_name (nil)
    # @option opts [String] parser_name (nil)
    # @option opts [String] base_name (Rattler::Runtime::RecursiveDescentParser)
    # @option opts [Array<String>] requires ([])
    # @option opts [Array<String>] includes ([])
    def initialize(rules, opts={})
      start_rule =
        opts[:start_rule] || rules.start_rule || (rules.first && rules.first.name)

      super rules.with_attrs(:start_rule => start_rule),
        @@default_opts.merge(:start_rule => start_rule).merge(opts)

      attrs[:name] ||= grammar_name || parser_name
    end

    alias_method :rules, :child

    # @param [Symbol] name the name of a parse rule in the grammar
    # @return [Rule] the parse rule referenced by +name+
    def rule(name)
      rules[name]
    end

    # @return [Analysis] a static analysis of the grammar rules
    def analysis
      rules.analysis
    end

    alias_method :with_rules, :with_children

  end
end
