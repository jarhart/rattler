require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class ZeroOrMoreGenerator < ExprGenerator #:nodoc:
    include RepeatGenerating
    include NestedSubGenerating

    def gen_assert(optional, scope={})
      @g << 'true'
    end

    def gen_disallow(optional, scope={})
      @g << 'false'
    end

    def gen_skip_top_level(repeat, scope={})
      @g << 'while '
      generate repeat.child, :intermediate_skip, scope
      (@g << '; end').newline
      @g << 'true'
    end

    protected

    def gen_result(captures)
      @g << captures
    end

  end

  # @private
  class NestedZeroOrMoreGenerator < ZeroOrMoreGenerator #:nodoc:
    include Nested
  end

  def ZeroOrMoreGenerator.nested(*args)
    NestedZeroOrMoreGenerator.new(*args)
  end

  # @private
  class TopLevelZeroOrMoreGenerator < ZeroOrMoreGenerator #:nodoc:
    include TopLevel
  end

  def ZeroOrMoreGenerator.top_level(*args)
    TopLevelZeroOrMoreGenerator.new(*args)
  end

end
