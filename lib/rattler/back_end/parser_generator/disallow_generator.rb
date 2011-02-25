require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class DisallowGenerator < ExprGenerator #:nodoc:

    def gen_basic(disallow)
      generate disallow.child, :disallow
    end

    def gen_assert(disallow)
      @g << 'false'
    end

    def gen_disallow(disallow)
      gen_basic disallow
    end

    def gen_skip_nested(disallow)
      gen_basic_nested disallow
    end

    def gen_skip_top_level(disallow)
      gen_basic_top_level disallow
    end

    def gen_dispatch_action_nested(disallow, code)
      atomic_block { gen_dispatch_action_top_level disallow, code }
    end

    def gen_dispatch_action_top_level(disallow, code)
      gen_action disallow,
        dispatch_action_result(code, :array_expr => '[]')
    end

    def gen_direct_action_nested(disallow, code)
      atomic_block { gen_direct_action_top_level disallow, code }
    end

    def gen_direct_action_top_level(disallow, code)
      gen_action disallow, direct_action_result(code)
    end

    def gen_token_nested(disallow)
      atomic_block { gen_token_top_level disallow }
    end

    def gen_token_top_level(disallow)
      gen_action disallow, "''"
    end

    def gen_intermediate(disallow)
      generate disallow.child, :intermediate_disallow
    end

    def gen_intermediate_disallow(disallow)
      gen_intermediate disallow
    end

    def gen_intermediate_skip(disallow)
      gen_intermediate disallow
    end

    private

    def gen_action(disallow, result_code)
      gen_intermediate disallow
      (@g << ' &&').newline << result_code
    end

  end

  # @private
  class NestedDisallowGenerator < DisallowGenerator #:nodoc:
    include Nested
    include NestedSubGenerating
  end

  def DisallowGenerator.nested(*args)
    NestedDisallowGenerator.new(*args)
  end

  # @private
  class TopLevelDisallowGenerator < DisallowGenerator #:nodoc:
    include TopLevel
    include TopLevelSubGenerating
  end

  def DisallowGenerator.top_level(*args)
    TopLevelDisallowGenerator.new(*args)
  end

end
