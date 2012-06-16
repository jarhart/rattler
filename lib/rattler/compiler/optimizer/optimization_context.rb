#
# = rattler/compiler/optimizer/optimization_context.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer
  #
  # +OptimizationContext+ provides contextual information to optimzations.
  #
  # @author Jason Arhart
  #
  class OptimizationContext

    @@cache = Hash.new {|h, attrs| h[attrs] = self.new(attrs) }

    def self.[](attrs)
      @@cache[attrs]
    end

    def initialize(attrs)
      @attrs = attrs
      @rules = @attrs[:rules]
    end

    attr_reader :type, :rules

    def start_rule
      rules && rules.start_rule
    end

    def analysis
      rules && rules.analysis
    end

    def capturing?
      @attrs[:type] == :capturing
    end

    def matching?
      @attrs[:type] == :matching
    end

    def inlineable?(rule_name)
      if rule = rules[rule_name]
        rule.attrs[:inline] and
        analysis.regular? rule_name
      end
    end

    def relavent?(rule)
      !rule.attrs[:inline] or
      analysis.referenced?(rule.name)
    end

    def with(new_attrs)
      self.class[@attrs.merge new_attrs]
    end

    def method_missing(symbol, *args)
      if args.empty? and @attrs.has_key? symbol
        @attrs[symbol]
      else
        super
      end
    end

    def respond_to?(symbol)
      super or @attrs.has_key? symbol
    end

  end
end
