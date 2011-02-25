require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class DispatchActionGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating

    def gen_basic_nested(action)
      generate action.child, :dispatch_action_nested, action_code(action)
    end

    def gen_basic_top_level(action)
      generate action.child, :dispatch_action_top_level, action_code(action)
    end

    def gen_dispatch_action_nested(inner, code)
      atomic_block { gen_dispatch_action_top_level inner, code }
    end

    def gen_dispatch_action_top_level(inner, code)
      @g.surround("(#{result_name} = ", ')') { gen_basic_nested inner }
      (@g << ' &&').newline << dispatch_action_result(code)
    end

    def gen_direct_action_nested(inner, code)
      atomic_block { gen_direct_action_top_level inner, code }
    end

    def gen_direct_action_top_level(inner, code)
      @g.surround("(#{result_name} = ", ')') { gen_basic_nested inner }
      (@g << ' &&').newline << direct_action_result(code)
    end

    private

    def action_code(action)
      DispatchActionCode.bindable_code action
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
