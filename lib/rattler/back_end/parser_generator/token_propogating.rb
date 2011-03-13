require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module TokenPropogating #:nodoc:
    def gen_token(parser, scope={})
      generate parser.child, :token, scope
    end
  end
end
