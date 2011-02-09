require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  
  # @private
  class FailGenerator < ExprGenerator #:nodoc:
    
    def gen_basic_nested(fail)
      case fail.attrs[:type]
      when :expr  then gen_fail_expr_nested fail.message
      when :rule  then gen_fail_rule_nested fail.message
      when :parse then gen_fail_parse_nested fail.message
      end
    end
    
    def gen_basic_top_level(fail)
      case fail.attrs[:type]
      when :expr  then gen_fail_expr_top_level fail.message
      when :rule  then gen_fail_rule_top_level fail.message
      when :parse then gen_fail_parse_top_level fail.message
      end
    end
    
    private
    
    def gen_fail_expr_nested(message)
      atomic_expr { gen_fail_expr_top_level message }
    end
    
    def gen_fail_expr_top_level(message)
      @g << "fail! { #{message.inspect} }"
    end
    
    def gen_fail_rule_nested(message)
      gen_fail_rule_top_level message
      @g.newline << 'false'
    end
    
    def gen_fail_rule_top_level(message)
      @g << "return(fail! { #{message.inspect} })"
    end
    
    def gen_fail_parse_nested(message)
      atomic_expr { gen_fail_parse_top_level message }
    end
    
    def gen_fail_parse_top_level(message)
      @g << "fail_parse { #{message.inspect} }"
    end
    
  end
  
  # @private
  class NestedFailGenerator < FailGenerator #:nodoc:
    include Nested
  end
  
  def FailGenerator.nested(*args)
    NestedFailGenerator.new(*args)
  end
  
  # @private
  class TopLevelFailGenerator < FailGenerator #:nodoc:
    include TopLevel
  end
  
  def FailGenerator.top_level(*args)
    TopLevelFailGenerator.new(*args)
  end
  
end
