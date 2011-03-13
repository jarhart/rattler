require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class DirectActionGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating

    def gen_basic_nested(action, scope={})
      generate action.child, :direct_action_nested, action.bindable_code, scope
    end

    def gen_basic_top_level(action, scope={})
      generate action.child, :direct_action_top_level, action.bindable_code, scope
    end

    def gen_dispatch_action_nested(inner, code, scope={})
      atomic_block { gen_dispatch_action_top_level inner, code, scope }
    end

    def gen_dispatch_action_top_level(inner, code, scope={})
      @g.surround("(#{result_name} = ", ')') { gen_basic_nested inner, scope }
      (@g << ' &&').newline << code.bind(scope, "[#{result_name}]")
    end

    def gen_direct_action_nested(inner, code, scope={})
      atomic_block { gen_direct_action_top_level inner, code, scope }
    end

    def gen_direct_action_top_level(inner, code, scope={})
      @g.surround("(#{result_name} = ", ')') { gen_basic_nested inner, scope }
      (@g << ' &&').newline << '(' << code.bind(scope, [result_name]) << ')'
    end

  end

  # @private
  class NestedDirectActionGenerator < DirectActionGenerator #:nodoc:
    include Nested
    include NestedSubGenerating
  end

  def DirectActionGenerator.nested(*args)
    NestedDirectActionGenerator.new(*args)
  end

  # @private
  class TopLevelDirectActionGenerator < DirectActionGenerator #:nodoc:
    include TopLevel
    include TopLevelSubGenerating
  end

  def DirectActionGenerator.top_level(*args)
    TopLevelDirectActionGenerator.new(*args)
  end

end
