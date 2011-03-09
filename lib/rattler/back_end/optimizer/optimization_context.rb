#
# = rattler/back_end/optimizer/optimization_context.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/back_end/optimizer'

module Rattler::BackEnd::Optimizer
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

    def standalone?
      start_rule && @attrs[:standalone]
    end

    def relavent?(rule)
      (not standalone? and not rule.attrs[:inline]) or
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
