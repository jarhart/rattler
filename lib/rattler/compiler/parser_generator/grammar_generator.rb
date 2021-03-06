require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator
  # @private
  class GrammarGenerator < RuleSetGenerator #:nodoc:

    def generate(parser, opts={})
      case parser
      when Grammar then gen_parser(parser, opts)
      when RuleSet then gen_rules(parser, opts)
      end
      self
    end

    def gen_parser(grammar, opts={})
      gen_encoding
      gen_requires grammar.requires
      gen_module(grammar) do
        gen_includes grammar.includes
        gen_rules(grammar.rules, opts)
      end
    end

    def gen_encoding
      (@g << "# encoding: utf-8").newline
    end

    def gen_requires(requires)
      requires.each {|_| @g.newline << "require #{_}" }
      @g.newline unless requires.empty?
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

    def gen_grammar_def(grammar_name)
      @g.newline
      nest_modules(grammar_name.split('::')) do |name|
        (@g << "# @private").newline
        module_block("module #{name} #:nodoc:") { yield }
      end
      gen_cli(:GrammarCLI, grammar_name)
    end

    def gen_parser_def(parser_name, base_name)
      @g.newline
      nest_modules(parser_name.split('::')) do |name|
        (@g << "# @private").newline
        module_block("class #{name} < #{base_name} #:nodoc:") { yield }
      end
      gen_cli(:ParserCLI, parser_name)
    end

    def gen_cli(cli, module_name)
      @g.newline.newline.block('if __FILE__ == $0') do
        %w{rubygems rattler}.each {|_| (@g << "require '#{_}'").newline }
        @g << "Rattler::Util::#{cli}.run(#{module_name})"
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
