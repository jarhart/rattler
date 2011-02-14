#
# = rattler/grammar/grammar_parser.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/grammar'

module Rattler::Grammar
  # @private
  class GrammarParser < Rattler::Runtime::WDMParser #:nodoc:
    
    include Metagrammar
    include Rattler::Parsers
    
    def initialize(*args)
      super
      @ws = nil
      @wc = Match[/[[:alnum:]_]/]
      @directive_stack = []
      
      @ws_stack = []
      @ws = nil
      @wc_stack = []
      @wc = Match[/[[:alnum:]_]/]
    end
    
    private
    
    def start_ws(e)
      @directive_stack.push(:type => :ws, :value => @ws)
      set_ws(e)
    end
    
    def set_ws(e)
      @ws = e
      true
    end
    
    def start_wc(e)
      @directive_stack.push(:type => :wc, :value => @wc)
      set_wc(e)
    end
    
    def set_wc(e)
      @wc = e
      true
    end
    
    def end_block
      if d = @directive_stack.pop
        case d[:type]
        when :wc then @wc = d[:value]
        when :ws then @ws = d[:value]
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
    
    def rule(name, parser)
      Rule[name, (@ws ? parser.with_ws(@ws) : parser)]
    end
    
    def literal(e)
      Match[Regexp.compile(Regexp.escape(eval(e, TOPLEVEL_BINDING)))]
    end
    
    def word_literal(e)
      Token[Sequence[
        Match[Regexp.compile(Regexp.escape(eval("%q#{e}", TOPLEVEL_BINDING)))],
        Disallow[@wc]
      ]]
    end
    
    def char_class(e)
      Match[Regexp.compile(e)]
    end
    
    def posix_class(name)
      char_class("[[:#{name.downcase}:]]")
    end
    
  end
end
