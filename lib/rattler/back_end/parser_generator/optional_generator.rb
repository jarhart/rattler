require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class OptionalGenerator < ExprGenerator #:nodoc:
    include NestedSubGenerating

    def gen_basic_nested(optional, scope={})
      atomic_expr { gen_basic_top_level optional, scope }
    end

    def gen_basic_top_level(optional, scope={})
      if optional.capturing?
        @g.surround("(#{result_name} = ", ')') do
          generate optional.child, :basic, scope
        end
        @g << " ? [#{result_name}] : []"
      else
        gen_skip_top_level optional, scope
      end
    end

    def gen_assert(optional, scope={})
      @g << 'true'
    end

    def gen_disallow(optional, scope={})
      @g << 'false'
    end

    def gen_dispatch_action_nested(optional, code, scope={})
      atomic_block { gen_dispatch_action_top_level optional, code, scope }
    end

    def gen_dispatch_action_top_level(optional, code, scope={})
      @g << "#{result_name} = "
      generate optional.child, :basic, scope
      @g.newline << code.bind(scope, "#{result_name} ? [#{result_name}] : []")
    end

    def gen_direct_action_nested(optional, code, scope={})
      atomic_block { gen_direct_action_top_level optional, code, scope }
    end

    def gen_direct_action_top_level(optional, code, scope={})
      @g << "#{result_name} = "
      generate optional.child, :basic, scope
      @g.newline <<
        '(' << code.bind(scope, ["(#{result_name} ? [#{result_name}] : [])"]) << ')'
    end

    def gen_token_nested(optional, scope={})
      atomic_block { gen_token_top_level optional, scope }
    end

    def gen_token_top_level(optional, scope={})
      generate optional.child, :token, scope
      @g << " || ''"
    end

    def gen_skip_nested(optional, scope={})
      atomic_block { gen_skip_top_level optional, scope }
    end

    def gen_skip_top_level(optional, scope={})
      generate optional.child, :intermediate_skip, scope
      @g.newline << 'true'
    end

    private

    def gen_capturing(optional, scope={})
      if optional.capturing?
        yield
      else
        gen_skip_top_level optional, scope
      end
    end

  end

  # @private
  class NestedOptionalGenerator < OptionalGenerator #:nodoc:
    include Nested
  end

  def OptionalGenerator.nested(*args)
    NestedOptionalGenerator.new(*args)
  end

  # @private
  class TopLevelOptionalGenerator < OptionalGenerator #:nodoc:
    include TopLevel
  end

  def OptionalGenerator.top_level(*args)
    TopLevelOptionalGenerator.new(*args)
  end

end
