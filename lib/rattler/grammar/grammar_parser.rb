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
      @ws_stack = []
      @ws = nil
    end
    
    start_rule :grammar
    
    private
    
    def start_ws(e)
      @ws_stack.push(@ws)
      set_ws(e)
    end
    
    def set_ws(e)
      @ws = e
      true
    end
    
    def end_ws
      @ws = @ws_stack.pop
      true
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
    
    def char_class(e)
      Match[Regexp.compile(e)]
    end
    
    def posix_class(name)
      char_class("[[:#{name}:]]")
    end
    
  end
end
