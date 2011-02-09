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
  class Grammar
    
    # The name of the default parser base class
    DEFAULT_PARSER_BASE = 'Rattler::Runtime::PackratParser'
    
    # @private
    def self.parsed(results, *_) #:nodoc:
      options, rules = results
      self.new(rules, options)
    end
    
    # @param rules [Rules] the parse rules that define the parser
    #
    # @option opts [String] start_rule (rules.first)
    # @option opts [String] grammar_name (nil)
    # @option opts [String] parser_name (nil)
    # @option opts [String] base_name (Rattler::Runtime::RecursiveDescentParser)
    # @option opts [Array<String>] requires ([])
    # @option opts [Array<String>] includes ([])
    def initialize(rules, opts={})
      @__rules__ = rules
      @start_rule = opts[:start_rule] || rules.first
      @grammar_name = opts[:grammar_name]
      @parser_name = opts[:parser_name]
      @base_name = opts[:base_name] || DEFAULT_PARSER_BASE
      @requires = opts[:requires] || []
      @includes = opts[:includes] || []
      @name = @grammar_name || @parser_name
    end
    
    attr_reader :start_rule, :grammar_name, :parser_name, :base_name, :name
    attr_reader :requires, :includes
    
    # @return the parse rules
    def rules
      @rules ||= @__rules__.optimized
    end
    
  end
end
