require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  
  # @private
  class LabelGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating
    
    def gen_basic(label)
      generate label.child, :gen_basic
    end
    
    def gen_dispatch_action(label, target, method_name)
      generate label.child, :gen_dispatch_action, target, method_name
    end
    
    def gen_direct_action(label, code)
      generate label.child, :gen_direct_action, code
    end
    
  end
  
  # @private
  class NestedLabelGenerator < LabelGenerator #:nodoc:
    include Nested
    include NestedGenerators
  end
  
  def LabelGenerator.nested(*args)
    NestedLabelGenerator.new(*args)
  end
  
  # @private
  class TopLevelLabelGenerator < LabelGenerator #:nodoc:
    include TopLevel
    include TopLevelGenerators
  end
  
  def LabelGenerator.top_level(*args)
    TopLevelLabelGenerator.new(*args)
  end
  
end
