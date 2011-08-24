require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class MatchGenerator < ExprGenerator #:nodoc:

    def gen_basic(match, scope = ParserScope.empty)
      @g << "@scanner.scan(#{match.re.inspect})"
    end

    def gen_assert(match, scope = ParserScope.empty)
      expr do
        gen_intermediate_assert match, scope
        @g << ' && true'
      end
    end

    def gen_disallow(match, scope = ParserScope.empty)
      expr do
        gen_intermediate_disallow match, scope
        @g << ' && true'
      end
    end

    def gen_token(match, scope = ParserScope.empty)
      gen_basic match, scope
    end

    def gen_skip(match, scope = ParserScope.empty)
      expr do
        gen_intermediate_skip match, scope
        @g << ' && true'
      end
    end

    def gen_intermediate_assert(match, scope = ParserScope.empty)
      @g << "@scanner.skip(#{/(?=#{match.re.source})/.inspect})"
    end

    def gen_intermediate_disallow(match, scope = ParserScope.empty)
      @g << "@scanner.skip(#{/(?!#{match.re.source})/.inspect})"
    end

    def gen_intermediate_skip(match, scope = ParserScope.empty)
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
