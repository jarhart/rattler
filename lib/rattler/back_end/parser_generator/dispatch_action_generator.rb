require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class DispatchActionGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating

    def gen_basic(action, scope = ParserScope.empty)
      generate action.child, :dispatch_action, action.bindable_code, scope
    end

    def gen_dispatch_action(inner, code, scope = ParserScope.empty)
      super { gen_nested inner, :basic, scope }
    end

    def gen_direct_action(inner, code, scope = ParserScope.empty)
      super { gen_nested inner, :basic, scope }
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
