require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator
  # @private
  module SkipPropogating #:nodoc:

    def gen_skip(parser, scope = ParserScope.empty)
      propogate_gen parser.child, :skip, scope
    end

    def gen_intermediate_skip(parser, scope = ParserScope.empty)
      propogate_gen parser.child, :intermediate_skip, scope
    end

  end
end
