require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator

  # @private
  class SuperGenerator < ExprGenerator #:nodoc:

    def gen_basic(*_)
      @g << 'super'
    end

    def gen_assert(*_)
      expr :block do
        lookahead { (@g << "#{result_name} = (super && true)").newline }
        @g << result_name
      end
    end

    def gen_disallow(*_)
      expr :block do
        lookahead { (@g << "#{result_name} = !super").newline }
        @g << result_name
      end
    end

    def gen_token(*_)
      @g << 'super.to_s'
    end

    def gen_skip(*_)
      expr { @g << 'super && true' }
    end

  end

  # @private
  class NestedSuperGenerator < SuperGenerator #:nodoc:
    include Nested
  end

  def SuperGenerator.nested(*args)
    NestedSuperGenerator.new(*args)
  end

  # @private
  class TopLevelSuperGenerator < SuperGenerator #:nodoc:
    include TopLevel
  end

  def SuperGenerator.top_level(*args)
    TopLevelSuperGenerator.new(*args)
  end

end
