require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class MatchGenerator < ExprGenerator #:nodoc:

    def gen_basic(match, scope={})
      @g << "@scanner.scan(#{match.re.inspect})"
    end

    def gen_assert_nested(match, scope={})
      atomic_expr { gen_assert_top_level match, scope }
    end

    def gen_assert_top_level(match, scope={})
      gen_intermediate_assert match, scope
      @g << ' && true'
    end

    def gen_disallow_nested(match, scope={})
      atomic_expr { gen_disallow_top_level match, scope }
    end

    def gen_disallow_top_level(match, scope={})
      gen_intermediate_disallow match, scope
      @g << ' && true'
    end

    def gen_dispatch_action_nested(match, code, scope={})
      atomic_block { gen_dispatch_action_top_level match, code, scope }
    end

    def gen_dispatch_action_top_level(match, code, scope={})
      @g.surround("(#{result_name} = ", ')') { gen_basic match, scope }
      (@g << ' &&').newline << code.bind(scope, "[#{result_name}]")
    end

    def gen_direct_action_nested(match, code, scope={})
      atomic_block { gen_direct_action_top_level match, code, scope }
    end

    def gen_direct_action_top_level(match, code, scope={})
      @g.surround("(#{result_name} = ", ')') { gen_basic match, scope }
      (@g << ' &&').newline << '(' << code.bind(scope, [result_name]) << ')'
    end

    def gen_token(match, scope={})
      gen_basic match, scope
    end

    def gen_skip_nested(match, scope={})
      atomic_expr { gen_skip_top_level match, scope }
    end

    def gen_skip_top_level(match, scope={})
      gen_intermediate_skip match, scope
      @g << ' && true'
    end

    def gen_intermediate_assert(match, scope={})
      @g << "@scanner.skip(#{/(?=#{match.re.source})/.inspect})"
    end

    def gen_intermediate_disallow(match, scope={})
      @g << "@scanner.skip(#{/(?!#{match.re.source})/.inspect})"
    end

    def gen_intermediate_skip(match, scope={})
      @g << "@scanner.skip(#{match.re.inspect})"
    end

  end

  # @private
  class NestedMatchGenerator < MatchGenerator #:nodoc:
    include Nested
  end

  def MatchGenerator.nested(*args)
    NestedMatchGenerator.new(*args)
  end

  # @private
  class TopLevelMatchGenerator < MatchGenerator #:nodoc:
    include TopLevel
  end

  def MatchGenerator.top_level(*args)
    TopLevelMatchGenerator.new(*args)
  end

end
