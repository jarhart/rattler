require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class TokenGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating

    def gen_basic(token, scope = ParserScope.empty)
      generate token.child, :token, scope
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
