require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  class RuleGenerator #:nodoc:

    Grammar = Rattler::Grammar::Grammar
    include Rattler::Parsers

    def initialize(g)
      @g = g
      @top_level_generator = TopLevelGenerator.new(@g)
    end

    def generate(parser, opts={})
      case parser
      when Rule then gen_rule parser
      else @top_level_generator.generate parser
      end
      self
    end

    def gen_rule(rule)
      (@g << "# @private").newline
      @g.block("def match_#{rule.name} #:nodoc:") do
        @g << "apply :match_#{rule.name}!"
      end.newline.newline
      (@g << "# @private").newline
      @g.block("def match_#{rule.name}! #:nodoc:") { generate rule.child }
    end

  end
end
