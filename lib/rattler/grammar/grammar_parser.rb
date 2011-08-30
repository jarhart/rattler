#
# = rattler/grammar/grammar_parser.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/grammar'

module Rattler::Grammar
  # @private
  class GrammarParser < Rattler::Runtime::ExtendedPackratParser #:nodoc:

    include Metagrammar
    include Rattler::Parsers

    def initialize(*args)
      super
      @ws = nil
      @wc = Match[/[[:alnum:]_]/]
      @inline = false
      @directive_stack = []
    end

    private

    def start_ws(e)
      @directive_stack.push :type => :ws, :value => @ws
      set_ws e
    end

    def set_ws(e)
      @ws = e
      true
    end

    def start_wc(e)
      @directive_stack.push :type => :wc, :value => @wc
      set_wc e
    end

    def set_wc(e)
      @wc = e
      true
    end

    def start_inline
      @directive_stack.push :type => :inline, :value => @inline
      set_inline
    end

    def set_inline
      @inline = true
    end

    def end_block
      if d = @directive_stack.pop
        case d[:type]
        when :wc      then @wc = d[:value]
        when :ws      then @ws = d[:value]
        when :inline  then @inline = d[:value]
        end
        true
      end
    end

    def heading(requires, modules, includes)
      requires.merge(modules.first || {}).merge(includes)
    end

    def parser_decl(name, base)
      {:parser_name => name, :base_name => base.first}
    end

    def list0(term_parser, sep_parser)
      ListParser[term_parser, sep_parser, 0, nil]
    end

    def list1(term_parser, sep_parser)
      ListParser[term_parser, sep_parser, 1, nil]
    end

    def semantic_assert(expr)
      Assert[SemanticAction[expr]]
    end

    def semantic_disallow(expr)
      Disallow[SemanticAction[expr]]
    end

    def side_effect(expr)
      Skip[SemanticAction[expr]]
    end

    def optional(parser)
      Repeat[parser, 0, 1]
    end

    def zero_or_more(parser)
      Repeat[parser, 0, nil]
    end

    def one_or_more(parser)
      Repeat[parser, 1, nil]
    end

    def rule(name, parser)
      Rule[name, (@ws ? parser.with_ws(@ws) : parser), {:inline => @inline}]
    end

    def literal(e)
      Match[Regexp.compile(Regexp.escape(eval(e, TOPLEVEL_BINDING)))]
    end

    def word_literal(e)
      Token[Sequence[literal("%q#{e}"), Disallow[@wc]]]
    end

    def char_class(e)
      Match[Regexp.compile(e)]
    end

    def posix_class(name)
      if name == 'WORD'
        Match[/[[:alnum:]_]/]
      else
        char_class("[[:#{name.downcase}:]]")
      end
    end

  end
end
