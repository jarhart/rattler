require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class ESymbolGenerator < ExprGenerator #:nodoc:

    def gen_basic(*_)
      @g << 'true'
    end

    alias_method :gen_assert, :gen_basic

    def gen_disallow(*_)
      @g << 'false'
    end

    def gen_dispatch_action(eof, code, scope = ParserScope.empty)
      @g << code.bind(scope, '[]')
    end

    def gen_direct_action(eof, code, scope = ParserScope.empty)
      expr { @g <<  code.bind(scope) }
    end

    def gen_token(*_)
      @g << "''"
    end

    alias_method :gen_skip, :gen_basic

  end

  # @private
  class NestedESymbolGenerator < ESymbolGenerator #:nodoc:
    include Nested
  end

  def ESymbolGenerator.nested(*args)
    NestedESymbolGenerator.new(*args)
  end

  # @private
  class TopLevelESymbolGenerator < ESymbolGenerator #:nodoc:
    include TopLevel
  end

  def ESymbolGenerator.top_level(*args)
    TopLevelESymbolGenerator.new(*args)
  end

end
