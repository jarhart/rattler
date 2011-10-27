#
# = rattler/grammar/grammar.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/grammar'

module Rattler::Grammar
  #
  # +Grammar+ represents a parsed grammar
  #
  # @author Jason Arhart
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
    # @option opts [String] start_rule (rules.first)
    # @option opts [String] grammar_name (nil)
    # @option opts [String] parser_name (nil)
    # @option opts [String] base_name (Rattler::Runtime::RecursiveDescentParser)
    # @option opts [Array<String>] requires ([])
    # @option opts [Array<String>] includes ([])
    def initialize(rules, opts={})
      super @@default_opts.merge(opts)

      case attrs[:start_rule]
      when Symbol, String
        attrs[:start_rule] = rules[start_rule.to_sym]
      when nil
        attrs[:start_rule] = rules.first
      end

      @rules = if start_rule.nil?
        rules
      else
        rules.with_attrs(:start_rule => start_rule.name)
      end

      attrs[:name] ||= grammar_name || parser_name
    end

    attr_reader :rules

    def rule(name)
      rules[name]
    end

    def analysis
      rules.analysis
    end

    def with_rules(new_rules)
      self.class.new new_rules, attrs
    end

  end
end
