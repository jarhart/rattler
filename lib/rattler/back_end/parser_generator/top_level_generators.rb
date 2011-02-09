require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module TopLevelGenerators #:nodoc:
    include Generators
    
    protected
    
    def factory_method
      :top_level
    end
    
  end
end
