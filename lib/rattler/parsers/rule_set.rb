#
# = rattler/parsers/rule_set.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  class RuleSet < Rattler::Util::Node

    # @private
    def self.parsed(results, *_) #:nodoc:
      self.new(results)
    end

    def initialize(*args)
      super
      @by_name = {}
      children.each {|rule| @by_name[rule.name] = rule }
    end

    alias_method :rules, :children

    def start_rule
      attrs[:start_rule]
    end

    def rule(name)
      @by_name[name]
    end

    def [](*args)
      if args.length == 1 and args[0].is_a?(Symbol)
        rule(args[0])
      else
        super
      end
    end

    def with_attrs(new_attrs)
      self.class.new(children, attrs.merge(new_attrs))
    end

    def with_rules(new_rules)
      self.class.new(new_rules, attrs)
    end

    def map_rules
      self.with_rules rules.map {|_| yield _ }
    end

    def select_rules
      self.with_rules rules.select {|_| yield _ }
    end

    def analysis
      @analysis ||= Rattler::Grammar::Analysis.new(self)
    end

  end
end
