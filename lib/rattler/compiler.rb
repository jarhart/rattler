require 'rattler'

module Rattler

  # The +Compiler+ module contains the classes and methods used to turn
  # parser models into ruby code.
  module Compiler
    autoload :GrammarParser, 'rattler/compiler/grammar_parser'
    autoload :Metagrammar, 'rattler/compiler/metagrammar'
    autoload :ParserGenerator, 'rattler/compiler/parser_generator'
    autoload :RubyGenerator, 'rattler/compiler/ruby_generator'
    autoload :Optimizer, 'rattler/compiler/optimizer'

    module ModuleMethods

      include Rattler::Parsers

      # Compile grammar source or a parser model into a new parser subclass of
      # +base+.
      #
      # @overload compile(base, grammar, opts)
      #   @param [Class] base the base class for the new parser class
      #   @param [String] grammar the grammar source to compile
      #   @return [Class] a new sublcass of +base+ with compiled match methods
      #
      # @overload compile(base, parser, opts)
      #   @param [Class] base the base class for the new parser class
      #   @param [Rattler::Parsers::Grammar,Rattler::Parsers::RuleSet,Rattler::Parsers::Rule]
      #     parser the parser model to compile
      #   @return [Class] a new sublcass of +base+ with compiled match methods
      #
      def compile_parser(base, grammar_or_parser, opts={})
        compile(Class.new(base), grammar_or_parser, opts)
      end

      # Compile grammar source or a parser model into match methods in a
      # module.
      #
      # @overload compile(mod, grammar, opts)
      #   @param [Module] mod the target module for the match methods
      #   @param [String] grammar the grammar source to compile
      #   @return [Module] +mod+
      #
      # @overload compile(mod, parser, opts)
      #   @param [Module] mod the target module for the match methods
      #   @param [Rattler::Parsers::Grammar,Rattler::Parsers::RuleSet,Rattler::Parsers::Rule]
      #     parser the parser model to compile
      #   @return [Module] +mod+
      #
      def compile(mod, grammar_or_parser, opts={})
        model = parser_model(grammar_or_parser)
        mod.module_eval ParserGenerator.code_for(model, opts)
        mod
      end

      private

      def parser_model(arg)
        case arg
        when Grammar, RuleSet, Rule then arg
        else GrammarParser.parse!(arg.to_str)
        end
      end
    end

    extend ModuleMethods
  end
end
