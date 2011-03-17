require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class OptionalGenerator < ExprGenerator #:nodoc:
    include NestedSubGenerating

    def gen_basic(optional, scope={})
      if optional.capturing?
        expr do
          @g.surround("(#{result_name} = ", ')') do
            generate optional.child, :basic, scope
          end
          @g << " ? [#{result_name}] : []"
        end
      else
        gen_skip optional, scope
      end
    end

    def gen_assert(optional, scope={})
      @g << 'true'
    end

    def gen_disallow(optional, scope={})
      @g << 'false'
    end

    def gen_dispatch_action(optional, code, scope={})
      expr :block do
        @g << "#{result_name} = "
        generate optional.child, :basic, scope
        @g.newline << code.bind(scope, "#{result_name} ? [#{result_name}] : []")
      end
    end

    def gen_direct_action(optional, code, scope={})
      expr :block do
        @g << "#{result_name} = "
        generate optional.child, :basic, scope
        @g.newline <<
          '(' << code.bind(scope, ["(#{result_name} ? [#{result_name}] : [])"]) << ')'
      end
    end

    def gen_token(optional, scope={})
      expr :block do
        generate optional.child, :token, scope
        @g << " || ''"
      end
    end

    def gen_skip(optional, scope={})
      expr :block do
        generate optional.child, :intermediate_skip, scope
        @g.newline << 'true'
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
