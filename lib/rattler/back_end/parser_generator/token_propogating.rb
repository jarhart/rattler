require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module TokenPropogating #:nodoc:
    def gen_token(parser)
      generate parser.child, :gen_token
    end
  end
end
