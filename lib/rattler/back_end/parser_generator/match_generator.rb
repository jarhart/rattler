require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class MatchGenerator < ExprGenerator #:nodoc:

    def gen_basic(match)
      @g << "@scanner.scan(#{match.re.inspect})"
    end

    def gen_assert_nested(match)
      atomic_expr { gen_assert_top_level match }
    end

    def gen_assert_top_level(match)
      gen_intermediate_assert match
      @g << ' && true'
    end

    def gen_disallow_nested(match)
      atomic_expr { gen_disallow_top_level match }
    end

    def gen_disallow_top_level(match)
      gen_intermediate_disallow match
      @g << ' && true'
    end

    def gen_dispatch_action_nested(match, code)
      atomic_block { gen_dispatch_action_top_level match, code }
    end

    def gen_dispatch_action_top_level(match, code)
      @g.surround("(#{result_name} = ", ')') { gen_basic match }
      (@g << ' &&').newline << dispatch_action_result(code)
    end

    def gen_direct_action_nested(match, code)
      atomic_block { gen_direct_action_top_level match, code }
    end

    def gen_direct_action_top_level(match, code)
      @g.surround("(#{result_name} = ", ')') { gen_basic match }
      (@g << ' &&').newline << direct_action_result(code)
    end

    def gen_token(match)
      gen_basic match
    end

    def gen_skip_nested(match)
      atomic_expr { gen_skip_top_level match }
    end

    def gen_skip_top_level(match)
      gen_intermediate_skip match
      @g << ' && true'
    end

    def gen_intermediate_assert(match)
      @g << "@scanner.skip(#{match.assert_re.inspect})"
    end

    def gen_intermediate_disallow(match)
      @g << "@scanner.skip(#{match.disallow_re.inspect})"
    end

    def gen_intermediate_skip(match)
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
