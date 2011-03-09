#
# = rattler/parsers/rule_set.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  class CombinatorParser < Rattler::Runtime::Parser

    def self.as_class(start_rule, rule_set)
      new_class = Class.new(self)
      new_class.send :define_method, :initialize do |source|
        super source, start_rule, rule_set
      end
      new_class
    end

    def initialize(source, start_rule, rule_set)
      super source
      @start_rule = start_rule
      @rule_set = rule_set
    end

    def __parse__
      @start_rule.parse(@scanner, @rule_set)
    end

  end
end
