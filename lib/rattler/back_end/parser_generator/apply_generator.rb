require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class ApplyGenerator < ExprGenerator #:nodoc:

    def gen_basic(apply, scope={})
      @g << "match(:#{apply.rule_name})"
    end

    def gen_assert(apply, scope={})
      expr :block do
        lookahead do
          @g.surround("#{result_name} = (", ')') { gen_bare_skip apply }
          @g.newline
        end
        @g << result_name
      end
    end

    def gen_disallow(apply, scope={})
      expr :block do
        lookahead do
          @g.surround("#{result_name} = !", '') { gen_basic apply }
          @g.newline
        end
        @g << result_name
      end
    end

    def gen_dispatch_action(apply, code, scope={})
      expr do
        gen_capture { gen_basic apply }
        @g << ' && ' << code.bind(scope, dispatch_action_args)
      end
    end

    def gen_direct_action(apply, code, scope={})
      expr do
        gen_capture { gen_basic apply }
        @g << ' && (' << code.bind(scope, direct_action_args) << ')'
      end
    end

    def gen_skip(apply, scope={})
      expr { gen_bare_skip apply }
    end

    def gen_intermediate_skip(apply, scope={})
      gen_basic apply
    end

    private

    def gen_bare_skip(apply)
      gen_intermediate_skip apply
      @g << ' && true'
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
