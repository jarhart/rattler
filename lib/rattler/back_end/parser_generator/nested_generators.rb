require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module NestedGenerators #:nodoc:
    include Generators
    
    protected
    
    def factory_method
      :nested
    end
    
  end
end
