require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class TokenGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating

    def gen_basic(token, scope={})
      generate token.child, :token, scope
    end

    def gen_dispatch_action_nested(token, code, scope={})
      atomic_block { gen_dispatch_action_top_level token, code, scope }
    end

    def gen_dispatch_action_top_level(token, code, scope={})
      @g.surround("(#{result_name} = ", ')') { gen_basic token, scope }
      (@g << ' &&').newline << code.bind(scope, "[#{result_name}]")
    end

    def gen_direct_action_nested(token, code, scope={})
      atomic_block { gen_direct_action_top_level token, code, scope }
    end

    def gen_direct_action_top_level(token, code, scope={})
      @g.surround("(#{result_name} = ", ')') { gen_basic token, scope }
      (@g << ' &&').newline << '(' << code.bind(scope, [result_name]) << ')'
    end

  end

  # @private
  class NestedTokenGenerator < TokenGenerator #:nodoc:
    include Nested
    include NestedSubGenerating
  end

  def TokenGenerator.nested(*args)
    NestedTokenGenerator.new(*args)
  end

  # @private
  class TopLevelTokenGenerator < TokenGenerator #:nodoc:
    include TopLevel
    include TopLevelSubGenerating
  end

  def TokenGenerator.top_level(*args)
    TopLevelTokenGenerator.new(*args)
  end

end
