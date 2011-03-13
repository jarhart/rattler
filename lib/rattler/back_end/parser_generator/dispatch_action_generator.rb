require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class DispatchActionGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating

    def gen_basic_nested(action, scope={})
      generate action.child, :dispatch_action_nested, action.bindable_code, scope
    end

    def gen_basic_top_level(action, scope={})
      generate action.child, :dispatch_action_top_level, action.bindable_code, scope
    end

    def gen_dispatch_action_nested(inner, code, scope={})
      atomic_block { gen_dispatch_action_top_level inner, code }
    end

    def gen_dispatch_action_top_level(inner, code, scope={})
      @g.surround("(#{result_name} = ", ')') { gen_basic_nested inner }
      (@g << ' &&').newline << code.bind(scope, "[#{result_name}]")
    end

    def gen_direct_action_nested(inner, code, scope={})
      atomic_block { gen_direct_action_top_level inner, code }
    end

    def gen_direct_action_top_level(inner, code, scope={})
      @g.surround("(#{result_name} = ", ')') { gen_basic_nested inner }
      (@g << ' &&').newline << '(' << code.bind(scope, [result_name]) << ')'
    end

  end

  # @private
  class NestedDispatchActionGenerator < DispatchActionGenerator #:nodoc:
    include Nested
    include NestedSubGenerating
  end

  def DispatchActionGenerator.nested(*args)
    NestedDispatchActionGenerator.new(*args)
  end

  # @private
  class TopLevelDispatchActionGenerator < DispatchActionGenerator #:nodoc:
    include TopLevel
    include TopLevelSubGenerating
  end

  def DispatchActionGenerator.top_level(*args)
    TopLevelDispatchActionGenerator.new(*args)
  end

end
