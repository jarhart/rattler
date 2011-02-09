require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module PredicatePropogating #:nodoc:
    
    def gen_assert(parser)
      generate parser.child, :gen_assert
    end
    
    def gen_disallow(parser)
      generate parser.child, :gen_disallow
    end
    
    def gen_intermediate_assert(parser)
      generate parser.child, :gen_intermediate_assert
    end
    
    def gen_intermediate_disallow(parser)
      generate parser.child, :gen_intermediate_disallow
    end
    
  end
end
