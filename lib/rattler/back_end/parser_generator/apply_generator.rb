require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  
  # @private
  class ApplyGenerator < ExprGenerator #:nodoc:
    
    def gen_basic(apply)
      @g << "match(:#{apply.rule_name})"
    end
    
    def gen_assert_nested(apply)
      atomic_block { gen_assert_top_level apply }
    end
    
    def gen_assert_top_level(apply)
      lookahead do
        @g.surround("#{result_name} = (", ')') { gen_skip_top_level apply }
        @g.newline
      end
      @g << result_name
    end
    
    def gen_disallow_nested(apply)
      atomic_block { gen_disallow_top_level apply }
    end
    
    def gen_disallow_top_level(apply)
      lookahead do
        @g.surround("#{result_name} = !", '') { gen_basic_nested apply }
        @g.newline
      end
      @g << result_name
    end
    
    def gen_dispatch_action_nested(apply, target, method_name)
      atomic_expr { gen_dispatch_action_top_level apply, target, method_name }
    end
    
    def gen_dispatch_action_top_level(apply, target, method_name)
      @g.surround("(#{result_name} = ", ')') { gen_basic apply }
      @g << ' && ' << dispatch_action_result(target, method_name)
    end
    
    def gen_direct_action_nested(apply, action)
      atomic_expr { gen_direct_action_top_level apply, action }
    end
    
    def gen_direct_action_top_level(apply, action)
      @g.surround("(#{result_name} = ", ')') { gen_basic apply }
      @g << ' && ' << direct_action_result(action)
    end
    
    def gen_skip_nested(apply)
      atomic_expr { gen_skip_top_level apply }
    end
    
    def gen_skip_top_level(apply)
      gen_intermediate_skip apply
      @g << ' && true'
    end
    
    def gen_intermediate_skip(apply)
      gen_basic apply
    end
    
  end
  
  # @private
  class NestedApplyGenerator < ApplyGenerator #:nodoc:
    include Nested
  end
  
  def ApplyGenerator.nested(*args)
    NestedApplyGenerator.new(*args)
  end
  
  # @private
  class TopLevelApplyGenerator < ApplyGenerator #:nodoc:
    include TopLevel
  end
  
  def ApplyGenerator.top_level(*args)
    TopLevelApplyGenerator.new(*args)
  end
  
end
