require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  
  # @private
  class OptionalGenerator < ExprGenerator #:nodoc:
    include NestedGenerators
    
    def gen_basic_nested(optional)
      atomic_expr { gen_basic_top_level optional }
    end
    
    def gen_basic_top_level(optional)
      if optional.capturing?
        @g.surround("(#{result_name} = ", ')') { generate optional.child }
        @g << " ? [#{result_name}] : []"
      else
        gen_skip_top_level optional
      end
    end
    
    def gen_assert(optional)
      @g << 'true'
    end
    
    def gen_disallow(optional)
      @g << 'false'
    end
    
    def gen_dispatch_action_nested(optional, target, method_name)
      atomic_block { gen_dispatch_action_top_level optional, target, method_name }
    end
    
    def gen_dispatch_action_top_level(optional, target, method_name)
      @g << "#{result_name} = "
      generate optional.child
      @g.newline << dispatch_action_result(target, method_name,
          :array_expr => "#{result_name} ? [#{result_name}] : []")
    end
    
    def gen_direct_action_nested(optional, action)
      atomic_block { gen_direct_action_top_level optional, action }
    end
    
    def gen_direct_action_top_level(optional, action)
      @g << "#{result_name} = "
      generate optional.child
      @g.newline << direct_action_result(action,
          :bind_args => ["(#{result_name} ? [#{result_name}] : [])"])
    end
    
    def gen_token_nested(optional)
      atomic_block { gen_token_top_level optional }
    end
    
    def gen_token_top_level(optional)
      generate optional.child, :gen_token
      @g << " || ''"
    end
    
    def gen_skip_nested(optional)
      atomic_block { gen_skip_top_level optional }
    end
    
    def gen_skip_top_level(optional)
      generate optional.child, :gen_intermediate_skip
      @g.newline << 'true'
    end
    
    private
    
    def gen_capturing(optional)
      if optional.capturing?
        yield
      else
        gen_skip_top_level optional
      end
    end
    
  end
  
  # @private
  class NestedOptionalGenerator < OptionalGenerator #:nodoc:
    include Nested
  end
  
  def OptionalGenerator.nested(*args)
    NestedOptionalGenerator.new(*args)
  end
  
  # @private
  class TopLevelOptionalGenerator < OptionalGenerator #:nodoc:
    include TopLevel
  end
  
  def OptionalGenerator.top_level(*args)
    TopLevelOptionalGenerator.new(*args)
  end
  
end
