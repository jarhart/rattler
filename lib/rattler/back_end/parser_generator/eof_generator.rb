require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class EofGenerator < ExprGenerator #:nodoc:

    def gen_basic(*_)
      @g << '@scanner.eos?'
    end

    alias_method :gen_assert, :gen_basic

    def gen_disallow(*_)
      expr { @g << '!@scanner.eos?' }
    end

    def gen_dispatch_action(eof, code, scope = ParserScope.empty)
      gen_symantic code.bind(scope, '[]')
    end

    def gen_direct_action(eof, code, scope = ParserScope.empty)
      gen_symantic '(' + code.bind(scope) + ')'
    end

    def gen_token(*_)
      gen_symantic "''"
    end

    alias_method :gen_skip, :gen_basic

    private

    def gen_symantic(result)
      expr { @g << "#{result} if @scanner.eos?" }
    end

  end

  # @private
  class NestedEofGenerator < EofGenerator #:nodoc:
    include Nested
  end

  def EofGenerator.nested(*args)
    NestedEofGenerator.new(*args)
  end

  # @private
  class TopLevelEofGenerator < EofGenerator #:nodoc:
    include TopLevel
  end

  def EofGenerator.top_level(*args)
    TopLevelEofGenerator.new(*args)
  end

end
