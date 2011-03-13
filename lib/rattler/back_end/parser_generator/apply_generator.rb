require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class ApplyGenerator < ExprGenerator #:nodoc:

    def gen_basic(apply, scope={})
      @g << "match(:#{apply.rule_name})"
    end

    def gen_assert_nested(apply, scope={})
      atomic_block { gen_assert_top_level apply }
    end

    def gen_assert_top_level(apply, scope={})
      lookahead do
        @g.surround("#{result_name} = (", ')') { gen_skip_top_level apply }
        @g.newline
      end
      @g << result_name
    end

    def gen_disallow_nested(apply, scope={})
      atomic_block { gen_disallow_top_level apply }
    end

    def gen_disallow_top_level(apply, scope={})
      lookahead do
        @g.surround("#{result_name} = !", '') { gen_basic_nested apply }
        @g.newline
      end
      @g << result_name
    end

    def gen_dispatch_action_nested(apply, code, scope={})
      atomic_expr { gen_dispatch_action_top_level apply, code }
    end

    def gen_dispatch_action_top_level(apply, code, scope={})
      @g.surround("(#{result_name} = ", ')') { gen_basic apply }
      @g << ' && ' << code.bind(scope, "[#{result_name}]")
    end

    def gen_direct_action_nested(apply, code, scope={})
      atomic_expr { gen_direct_action_top_level apply, code }
    end

    def gen_direct_action_top_level(apply, code, scope={})
      @g.surround("(#{result_name} = ", ')') { gen_basic apply }
      @g << ' && (' << code.bind(scope, [result_name]) << ')'
    end

    def gen_skip_nested(apply, scope={})
      atomic_expr { gen_skip_top_level apply }
    end

    def gen_skip_top_level(apply, scope={})
      gen_intermediate_skip apply
      @g << ' && true'
    end

    def gen_intermediate_skip(apply, scope={})
      gen_basic apply
    end

  end

  # @private
  class NestedApplyGenerator < ApplyGenerator #:nodoc:
    include Nested
  end

  def ApplyGenerator.nested(*args)
    NestedApplyGenerator.new(*args)
  end

  # @private
  class TopLevelApplyGenerator < ApplyGenerator #:nodoc:
    include TopLevel
  end

  def ApplyGenerator.top_level(*args)
    TopLevelApplyGenerator.new(*args)
  end

end
