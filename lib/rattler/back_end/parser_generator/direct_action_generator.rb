require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  
  # @private
  class DirectActionGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating
    
    def gen_basic_nested(action)
      generate action.child, :gen_direct_action_nested, action.bindable_code
    end
    
    def gen_basic_top_level(action)
      generate action.child, :gen_direct_action_top_level, action.bindable_code
    end
    
    def gen_dispatch_action_nested(inner, target, method_name)
      atomic_block { gen_dispatch_action_top_level inner, target, method_name }
    end
    
    def gen_dispatch_action_top_level(inner, target, method_name)
      @g.surround("(#{result_name} = ", ')') { gen_basic_nested inner }
      (@g << ' &&').newline << dispatch_action_result(target, method_name)
    end
    
    def gen_direct_action_nested(inner, code)
      atomic_block { gen_direct_action_top_level inner, code }
    end
    
    def gen_direct_action_top_level(inner, code)
      @g.surround("(#{result_name} = ", ')') { gen_basic_nested inner }
      (@g << ' &&').newline << direct_action_result(code)
    end
    
  end
  
  # @private
  class NestedDirectActionGenerator < DirectActionGenerator #:nodoc:
    include Nested
    include NestedGenerators
  end
  
  def DirectActionGenerator.nested(*args)
    NestedDirectActionGenerator.new(*args)
  end
  
  # @private
  class TopLevelDirectActionGenerator < DirectActionGenerator #:nodoc:
    include TopLevel
    include TopLevelGenerators
  end
  
  def DirectActionGenerator.top_level(*args)
    TopLevelDirectActionGenerator.new(*args)
  end
  
end
