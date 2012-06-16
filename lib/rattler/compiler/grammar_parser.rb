#
# = rattler/grammar/grammar_parser.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/compiler'

module Rattler::Compiler
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

    def expand_relative(e)
      "File.expand_path(#{e}, File.dirname(__FILE__))"
    end

    def heading(requires, modules, includes, start)
      requires.
        merge(modules.first || {}).
        merge(includes).
        merge(start.first || {})
    end

    def parser_decl(name, base)
      {:parser_name => name, :base_name => base.first}
    end

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

    def start_fragments
      @directive_stack.push :type => :fragments, :value => [@ws, @inline]
      set_fragments
    end

    def set_fragments
      @ws = nil
      @inline = true
    end

    def end_block
      if d = @directive_stack.pop
        case d[:type]
        when :wc        then @wc = d[:value]
        when :ws        then @ws = d[:value]
        when :inline    then @inline = d[:value]
        when :fragments then @ws, @inline = d[:value]
        end
        true
      end
    end

    def list0(term_parser, sep_parser)
      ListParser[term_parser, sep_parser, 0, nil]
    end

    def list1(term_parser, sep_parser)
      ListParser[term_parser, sep_parser, 1, nil]
    end

    def attributed(o, action)
      (o + [action]).reduce {|s, a| s >> a }
    end

    def optional(parser)
      parser.optional
    end

    def zero_or_more(parser)
      parser.zero_or_more
    end

    def one_or_more(parser)
      parser.one_or_more
    end

    def rule(name, parser)
      Rule[name, finish_expr(parser, name), {:inline => @inline}]
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

    def finish_expr(parser, rule_name)
      parser = finish_super(parser, rule_name)
      @ws ? parser.with_ws(@ws) : parser
    end

    def finish_super(parser, rule_name)
      case parser
      when Super
        parser.with_attrs(:rule_name => rule_name)
      when Eof, ESymbol
        parser
      when Parser
        parser.with_children(parser.map {|_| finish_super(_, rule_name) })
      else
        parser
      end
    end

  end
end
