require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module TokenPropogating #:nodoc:
    def gen_token(parser, scope={})
      propogate_gen parser.child, :token, scope
    end
  end
end
