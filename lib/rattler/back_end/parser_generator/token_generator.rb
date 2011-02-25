require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class TokenGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating

    def gen_basic(token)
      generate token.child, :token
    end

    def gen_dispatch_action_nested(token, target, method_name)
      atomic_block { gen_dispatch_action_top_level token, target, method_name }
    end

    def gen_dispatch_action_top_level(token, target, method_name)
      @g.surround("(#{result_name} = ", ')') { gen_basic token }
      (@g << ' &&').newline << dispatch_action_result(target, method_name)
    end

    def gen_direct_action_nested(token, action)
      atomic_block { gen_direct_action_top_level token, action }
    end

    def gen_direct_action_top_level(token, action)
      @g.surround("(#{result_name} = ", ')') { gen_basic token }
      (@g << ' &&').newline << direct_action_result(action)
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
