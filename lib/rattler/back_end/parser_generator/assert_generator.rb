require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  
  # @private
  class AssertGenerator < ExprGenerator #:nodoc:
    
    def gen_basic(assert)
      generate assert.child, :gen_assert
    end
    
    def gen_assert(assert)
      gen_basic assert
    end
    
    def gen_disallow(assert)
      @g << 'false'
    end
    
    def gen_skip_nested(assert)
      gen_basic_nested assert
    end
    
    def gen_skip_top_level(assert)
      gen_basic_top_level assert
    end
    
    def gen_dispatch_action_nested(assert, target, method_name)
      atomic_block { gen_dispatch_action_top_level assert, target, method_name }
    end
    
    def gen_dispatch_action_top_level(assert, target, method_name)
      gen_action assert,
        dispatch_action_result(target, method_name, :array_expr => '[]')
    end
    
    def gen_direct_action_nested(assert, code)
      atomic_block { gen_direct_action_top_level assert, code }
    end
    
    def gen_direct_action_top_level(assert, code)
      gen_action assert, direct_action_result(code)
    end
    
    def gen_token_nested(assert)
      atomic_block { gen_token_top_level assert }
    end
    
    def gen_token_top_level(assert)
      gen_action assert, "''"
    end
    
    def gen_intermediate(assert)
      generate assert.child, :gen_intermediate_assert
    end
    
    def gen_intermediate_assert(assert)
      gen_intermediate assert
    end
    
    def gen_intermediate_skip(assert)
      gen_intermediate assert
    end
    
    private
    
    def gen_action(assert, result_code)
      gen_intermediate assert
      (@g << ' &&').newline << result_code
    end
    
  end
  
  # @private
  class NestedAssertGenerator < AssertGenerator #:nodoc:
    include Nested
    include NestedGenerators
  end
  
  def AssertGenerator.nested(*args)
    NestedAssertGenerator.new(*args)
  end
  
  # @private
  class TopLevelAssertGenerator < AssertGenerator #:nodoc:
    include TopLevel
    include TopLevelGenerators
  end
  
  def AssertGenerator.top_level(*args)
    TopLevelAssertGenerator.new(*args)
  end
  
end
