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
    
    def generate(parser)
      case parser
      when Grammar  then gen_parser parser
      when Rules    then gen_rules parser
      when Rule     then gen_rule parser
      else @top_level_generator.generate parser
      end
      self
    end
    
    private
    
    def gen_parser(grammar)
      gen_requires grammar.requires
      gen_module(grammar) do
        gen_includes grammar.includes
        generate grammar.rules
      end
    end
    
    def gen_requires(requires)
      requires.each {|_| (@g << "require #{_}").newline }
      @g.newline
    end
    
    def gen_module(grammar)
      if grammar.grammar_name
        gen_grammar_def(grammar.grammar_name) { yield }
      elsif grammar.parser_name
        gen_parser_def(grammar.parser_name, grammar.base_name) { yield }
      else
        yield
      end
    end
    
    def gen_includes(includes)
      unless includes.empty?
        includes.each {|_| (@g << "include #{_}").newline }
        @g.newline
      end
    end
    
    def gen_rules(rules)
      @g.intersperse(rules, :newlines => 2) {|_| generate _ }
    end
    
    def gen_rule(rule)
      (@g << "# @private").newline
      @g.block("def match_#{rule.name} #:nodoc:") { generate rule.child }
    end
    
    def gen_grammar_def(grammar_name)
      nest_modules(grammar_name.split('::')) do |name|
        (@g << "# @private").newline
        module_block("module #{name} #:nodoc:") { yield }
      end
    end
    
    def gen_parser_def(parser_name, base_name)
      nest_modules(parser_name.split('::')) do |name|
        (@g << "# @private").newline
        module_block("class #{name} < #{base_name}") { yield }
      end
    end
    
    def nest_modules(path)
      mod, *rest = path
      if rest.empty?
        yield mod
      else
        @g.block("module #{mod}") { nest_modules(rest) {|_| yield _ } }
      end
    end
    
    def module_block(decl)
      @g.block(decl) do
        @g.newline
        yield
        @g.newline
      end
    end
    
  end
end
