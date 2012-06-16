require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator

  # @private
  class SkipGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating

    def gen_basic(skip, scope = ParserScope.empty)
      generate skip.child, :skip, scope
    end

    def gen_intermediate(skip, scope = ParserScope.empty)
      gen_intermediate_skip skip, scope
    end

  end

  # @private
  class NestedSkipGenerator < SkipGenerator #:nodoc:
    include Nested
    include NestedSubGenerating
  end

  def SkipGenerator.nested(*args)
    NestedSkipGenerator.new(*args)
  end

  # @private
  class TopLevelSkipGenerator < SkipGenerator #:nodoc:
    include TopLevel
    include TopLevelSubGenerating
  end

  def SkipGenerator.top_level(*args)
    TopLevelSkipGenerator.new(*args)
  end

end
