require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  
  # @private
  class SkipGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating
    
    def gen_basic(skip)
      generate skip.child, :gen_skip
    end
    
    def gen_dispatch_action_nested(skip, target, method_name)
      atomic_block { gen_dispatch_action_top_level skip, target, method_name }
    end
    
    def gen_dispatch_action_top_level(skip, target, method_name)
      gen_intermediate_skip skip
      (@g << ' &&').newline
      @g << dispatch_action_result(target, method_name, :array_expr => '[]')
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
      generate skip.child, :gen_intermediate_skip
    end
    
    def gen_intermediate_skip(skip)
      gen_intermediate skip
    end
    
  end
  
  # @private
  class NestedSkipGenerator < SkipGenerator #:nodoc:
    include Nested
    include NestedGenerators
  end
  
  def SkipGenerator.nested(*args)
    NestedSkipGenerator.new(*args)
  end
  
  # @private
  class TopLevelSkipGenerator < SkipGenerator #:nodoc:
    include TopLevel
    include TopLevelGenerators
  end
  
  def SkipGenerator.top_level(*args)
    TopLevelSkipGenerator.new(*args)
  end
  
end
