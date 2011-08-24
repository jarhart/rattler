require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module OptionalGenerating #:nodoc:

    def gen_assert(optional, scope = ParserScope.empty)
      @g << 'true'
    end

    def gen_disallow(optional, scope = ParserScope.empty)
      @g << 'false'
    end

    def gen_dispatch_action(optional, code, scope = ParserScope.empty)
      expr :block do
        gen_loop optional, scope
        @g.newline << code.bind(scope, "#{result_name} ? [#{result_name}] : []")
      end
    end

    def gen_direct_action(optional, code, scope = ParserScope.empty)
      expr :block do
        @g << "#{result_name} = "
        generate optional.child, :basic, scope
        @g.newline <<
          '(' << code.bind(scope.capture("(#{result_name} ? [#{result_name}] : [])")) << ')'
      end
    end

    def gen_token(optional, scope = ParserScope.empty)
      expr :block do
        generate optional.child, :token, scope
        @g << " || ''"
      end
    end

    def gen_skip(optional, scope = ParserScope.empty)
      expr :block do
        generate optional.child, :intermediate_skip, scope
        @g.newline << 'true'
      end
    end

    protected

    def gen_capturing(optional, scope)
      expr do
        @g.surround("(#{result_name} = ", ')') do
          generate optional.child, :basic, scope
        end
        @g << " ? [#{result_name}] : []"
      end
    end

    def gen_loop(optional, scope)
      @g << "#{result_name} = "
      generate optional.child, :basic, scope
    end

    def gen_result(optional, captures)
      @g.newline << captures
    end

  end
end
