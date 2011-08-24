require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class BackReferenceGenerator < ExprGenerator #:nodoc:

    def gen_basic(ref, scope = ParserScope.empty)
      @g << "@scanner.scan(#{ref.re_expr(scope)})"
    end

    def gen_assert(ref, scope = ParserScope.empty)
      expr do
        gen_intermediate_assert ref, scope
        @g << ' && true'
      end
    end

    def gen_disallow(ref, scope = ParserScope.empty)
      expr do
        gen_intermediate_disallow ref, scope
        @g << ' && true'
      end
    end

    def gen_token(ref, scope = ParserScope.empty)
      gen_basic ref, scope
    end

    def gen_skip(ref, scope = ParserScope.empty)
      expr do
        gen_intermediate_skip ref, scope
        @g << ' && true'
      end
    end

    def gen_intermediate_assert(ref, scope = ParserScope.empty)
      @g << "@scanner.skip(/(?=#{ref.re_source(scope)})/)"
    end

    def gen_intermediate_disallow(ref, scope = ParserScope.empty)
      @g << "@scanner.skip(/(?!#{ref.re_source(scope)})/)"
    end

    def gen_intermediate_skip(ref, scope = ParserScope.empty)
      @g << "@scanner.skip(#{ref.re_expr(scope)})"
    end

  end

  # @private
  class NestedBackReferenceGenerator < BackReferenceGenerator #:nodoc:
    include Nested
  end

  def BackReferenceGenerator.nested(*args)
    NestedBackReferenceGenerator.new(*args)
  end

  # @private
  class TopLevelBackReferenceGenerator < BackReferenceGenerator #:nodoc:
    include TopLevel
  end

  def BackReferenceGenerator.top_level(*args)
    TopLevelBackReferenceGenerator.new(*args)
  end

end
