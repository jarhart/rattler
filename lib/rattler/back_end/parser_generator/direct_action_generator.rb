require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class DirectActionGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating

    def gen_basic(action, scope={})
      generate action.child, :direct_action, action.bindable_code, scope
    end

    def gen_dispatch_action(inner, code, scope={})
      super { gen_nested inner, :basic, scope }
    end

    def gen_direct_action(inner, code, scope={})
      super { gen_nested inner, :basic, scope }
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
