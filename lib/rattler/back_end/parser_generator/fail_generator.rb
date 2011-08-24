require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class FailGenerator < ExprGenerator #:nodoc:

    def gen_basic(fail, scope = ParserScope.empty)
      case fail.attrs[:type]
      when :expr  then gen_fail_expr fail.message
      when :rule  then gen_fail_rule fail.message
      when :parse then gen_fail_parse fail.message
      end
    end

    private

    def gen_fail_expr(message)
      expr { @g << "fail! { #{message.inspect} }" }
    end

    def gen_fail_rule(message)
      @g << "return(fail! { #{message.inspect} })"
      @g.newline << 'false' if nested?
    end

    def gen_fail_parse(message)
      expr { @g << "fail_parse { #{message.inspect} }" }
    end

  end

  # @private
  class NestedFailGenerator < FailGenerator #:nodoc:
    include Nested
  end

  def FailGenerator.nested(*args)
    NestedFailGenerator.new(*args)
  end

  # @private
  class TopLevelFailGenerator < FailGenerator #:nodoc:
    include TopLevel
  end

  def FailGenerator.top_level(*args)
    TopLevelFailGenerator.new(*args)
  end

end
