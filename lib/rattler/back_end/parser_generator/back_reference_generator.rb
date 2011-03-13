require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class BackReferenceGenerator < ExprGenerator #:nodoc:

    def gen_basic(ref, scope={})
      @g << "@scanner.scan(#{ref.re_expr(scope)})"
    end

    def gen_assert_nested(ref, scope={})
      atomic_expr { gen_assert_top_level ref, scope }
    end

    def gen_assert_top_level(ref, scope={})
      gen_intermediate_assert ref, scope
      @g << ' && true'
    end

    def gen_disallow_nested(ref, scope={})
      atomic_expr { gen_disallow_top_level ref, scope }
    end

    def gen_disallow_top_level(ref, scope={})
      gen_intermediate_disallow ref, scope
      @g << ' && true'
    end

    def gen_dispatch_action_nested(ref, code, scope={})
      atomic_block { gen_dispatch_action_top_level ref, code, scope }
    end

    def gen_dispatch_action_top_level(ref, code, scope={})
      @g.surround("(#{result_name} = ", ')') { gen_basic ref, scope }
      (@g << ' &&').newline << code.bind(scope, "[#{result_name}]")
    end

    def gen_direct_action_nested(ref, code, scope={})
      atomic_block { gen_direct_action_top_level ref, code, scope }
    end

    def gen_direct_action_top_level(ref, code, scope={})
      @g.surround("(#{result_name} = ", ')') { gen_basic ref, scope }
      (@g << ' &&').newline << '(' << code.bind(scope, [result_name]) << ')'
    end

    def gen_token(ref, scope={})
      gen_basic ref, scope
    end

    def gen_skip_nested(ref, scope={})
      atomic_expr { gen_skip_top_level ref, scope }
    end

    def gen_skip_top_level(ref, scope={})
      gen_intermediate_skip ref, scope
      @g << ' && true'
    end

    def gen_intermediate_assert(ref, scope={})
      @g << "@scanner.skip(/(?=#{ref.re_source(scope)})/)"
    end

    def gen_intermediate_disallow(ref, scope={})
      @g << "@scanner.skip(/(?!#{ref.re_source(scope)})/)"
    end

    def gen_intermediate_skip(ref, scope={})
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
