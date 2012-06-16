require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator
  # @private
  module PredicatePropogating #:nodoc:

    def gen_assert(parser, scope = ParserScope.empty)
      propogate_gen parser.child, :assert, scope
    end

    def gen_disallow(parser, scope = ParserScope.empty)
      propogate_gen parser.child, :disallow, scope
    end

    def gen_intermediate_assert(parser, scope = ParserScope.empty)
      propogate_gen parser.child, :intermediate_assert, scope
    end

    def gen_intermediate_disallow(parser, scope = ParserScope.empty)
      propogate_gen parser.child, :intermediate_disallow, scope
    end

  end
end
