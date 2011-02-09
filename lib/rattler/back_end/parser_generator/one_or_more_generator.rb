require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  
  # @private
  class OneOrMoreGenerator < ZeroOrMoreGenerator #:nodoc:
    include PredicatePropogating
    
    def gen_basic_top_level(one_or_more)
      if one_or_more.capturing?
        required_match { super }
      else
        gen_skip_top_level one_or_more
      end
    end
    
    def gen_dispatch_action_top_level(one_or_more, target, method_name)
      required_match { super }
    end
    
    def gen_direct_action_top_level(one_or_more, action)
      required_match { super }
    end
    
    def gen_token_top_level(one_or_more)
      required_match { super }
    end
    
    def gen_skip_top_level(one_or_more)
      (@g << "#{result_name} = false").newline
      @g << 'while '
      generate one_or_more.child, :gen_intermediate_skip
      @g.block('') { @g << "#{result_name} = true" }.newline
      @g << result_name
    end
    
    private
    
    def required_match
      yield
      @g << " unless #{accumulator_name}.empty?"
    end
    
  end
  
  # @private
  class NestedOneOrMoreGenerator < OneOrMoreGenerator #:nodoc:
    include Nested
    include NestedGenerators
  end
  
  def OneOrMoreGenerator.nested(*args)
    NestedOneOrMoreGenerator.new(*args)
  end
  
  # @private
  class TopLevelOneOrMoreGenerator < OneOrMoreGenerator #:nodoc:
    include TopLevel
    include TopLevelGenerators
  end
  
  def OneOrMoreGenerator.top_level(*args)
    TopLevelOneOrMoreGenerator.new(*args)
  end
  
end
