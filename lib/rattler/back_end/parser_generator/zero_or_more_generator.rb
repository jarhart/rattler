require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  
  # @private
  class ZeroOrMoreGenerator < ExprGenerator #:nodoc:
    include RepeatGenerating
    
    def gen_assert(optional)
      @g << 'true'
    end
    
    def gen_disallow(optional)
      @g << 'false'
    end
    
    def gen_skip_top_level(repeat)
      @g << 'while '
      generate repeat.child, :gen_intermediate_skip
      (@g << '; end').newline
      @g << 'true'
    end
    
    protected

    def gen_result(captures)
      @g << captures
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
    include NestedGenerators
  end
  
  def ZeroOrMoreGenerator.top_level(*args)
    TopLevelZeroOrMoreGenerator.new(*args)
  end
  
end
