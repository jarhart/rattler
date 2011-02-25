require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class SkipGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating

    def gen_basic(skip)
      generate skip.child, :skip
    end

    def gen_dispatch_action_nested(skip, code)
      atomic_block { gen_dispatch_action_top_level skip, code }
    end

    def gen_dispatch_action_top_level(skip, code)
      gen_intermediate_skip skip
      (@g << ' &&').newline
      @g << dispatch_action_result(code, :array_expr => '[]')
    end

    def gen_direct_action_nested(skip, action)
      atomic_block { gen_direct_action_top_level skip, action }
    end

    def gen_direct_action_top_level(skip, action)
      gen_intermediate_skip skip
      (@g << ' &&').newline
      @g << direct_action_result(action, :bind_args => [])
    end

    def gen_intermediate(skip)
      generate skip.child, :intermediate_skip
    end

    def gen_intermediate_skip(skip)
      gen_intermediate skip
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
