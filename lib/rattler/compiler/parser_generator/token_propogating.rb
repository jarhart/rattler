require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator
  # @private
  module TokenPropogating #:nodoc:
    def gen_token(parser, scope = ParserScope.empty)
      propogate_gen parser.child, :token, scope
    end
  end
end
