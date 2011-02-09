require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  
  # @private
  class ZeroOrMoreGenerator < ExprGenerator #:nodoc:
    
    def gen_basic_nested(zero_or_more)
      atomic_block { gen_basic_top_level zero_or_more }
    end
    
    def gen_basic_top_level(zero_or_more)
      if zero_or_more.capturing?
        gen_loop(zero_or_more)
        @g << accumulator_name
      else
        gen_skip_top_level zero_or_more
      end
    end
    
    def gen_assert(optional)
      @g << 'true'
    end
    
    def gen_disallow(optional)
      @g << 'false'
    end
    
    def gen_dispatch_action_nested(zero_or_more, target, method_name)
      atomic_block do
        gen_dispatch_action_top_level zero_or_more, target, method_name
      end
    end
    
    def gen_dispatch_action_top_level(zero_or_more, target, method_name)
      gen_loop zero_or_more
      @g << dispatch_action_result(target, method_name,
          :array_expr => "select_captures(#{accumulator_name})")
    end
    
    def gen_direct_action_nested(zero_or_more, action)
      atomic_block { gen_direct_action_top_level zero_or_more, action }
    end
    
    def gen_direct_action_top_level(zero_or_more, action)
      gen_loop zero_or_more
      @g << direct_action_result(action,
          :bind_args => ["select_captures(#{accumulator_name})"])
    end
    
    def gen_token_nested(zero_or_more)
      atomic_block { gen_token_top_level zero_or_more }
    end
    
    def gen_token_top_level(zero_or_more)
      gen_loop zero_or_more, :gen_token
      @g << "#{accumulator_name}.join"
    end
    
    def gen_skip_nested(zero_or_more)
      atomic_block { gen_skip_top_level zero_or_more }
    end
    
    def gen_skip_top_level(zero_or_more)
      @g << 'while '
      generate zero_or_more.child, :gen_intermediate_skip
      (@g << '; end').newline
      @g << 'true'
    end
    
    private
    
    def gen_loop(zero_or_more, gen_method = :gen_basic)
      (@g << "#{accumulator_name} = []").newline
      @g << "while #{result_name} = "
      generate zero_or_more.child, gen_method
      @g.block('') { @g << "#{accumulator_name} << #{result_name}" }.newline
    end
    
    def accumulator_name
      "a#{repeat_level}"
    end
    
  end
  
  # @private
  class NestedZeroOrMoreGenerator < ZeroOrMoreGenerator #:nodoc:
    include Nested
    include NestedGenerators
  end
  
  def ZeroOrMoreGenerator.nested(*args)
    NestedZeroOrMoreGenerator.new(*args)
  end
  
  # @private
  class TopLevelZeroOrMoreGenerator < ZeroOrMoreGenerator #:nodoc:
    include TopLevel
    include TopLevelGenerators
  end
  
  def ZeroOrMoreGenerator.top_level(*args)
    TopLevelZeroOrMoreGenerator.new(*args)
  end
  
end
