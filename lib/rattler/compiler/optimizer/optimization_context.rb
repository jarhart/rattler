require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer

  # +OptimizationContext+ provides contextual information to optimzations.
  class OptimizationContext

    # @private
    @@cache = Hash.new {|h, attrs| h[attrs] = self.new(attrs) }

    # @param [Hash] attrs attributes of an optimization context
    # @return [OptimizationContext] an optimization context with the given
    #   attributes
    def self.[](attrs)
      @@cache[attrs]
    end

    # @param [Hash] attrs attributes of an optimization context
    def initialize(attrs)
      @attrs = attrs
      @rules = @attrs[:rules]
    end

    attr_reader :type, :rules

    # @return [Symbol] the name of the start rule
    def start_rule
      rules && rules.start_rule
    end

    # @return [Rattler::Parsers::Analysis] an analysis of the parse rules
    def analysis
      rules && rules.analysis
    end

    # @return whether this is a capturing context
    def capturing?
      @attrs[:type] == :capturing
    end

    # @return whether this is a matching context
    def matching?
      @attrs[:type] == :matching
    end

    # @param [Symbol] rule_name the name of a rule in the context
    # @return whether the rule can be inlined
    def inlineable?(rule_name)
      if rule = rules[rule_name]
        rule.attrs[:inline] and
        analysis.regular? rule_name
      end
    end

    # @param [Rattler::Parsers::Rule] rule a rule in the context
    # @return whether the rule is relavent to the optimized parser
    def relavent?(rule)
      !rule.attrs[:inline] or
      analysis.referenced?(rule.name)
    end

    # @param [Hash] new_attrs additional attributes
    # @return [OptimizationContext] a new context with +new_attrs+ added
    def with(new_attrs)
      self.class[@attrs.merge new_attrs]
    end

    # @private
    def method_missing(symbol, *args) #:nodoc:
      if args.empty? and @attrs.has_key? symbol
        @attrs[symbol]
      else
        super
      end
    end

    # @private
    def respond_to?(symbol) #:nodoc:
      super or @attrs.has_key? symbol
    end

  end
end
