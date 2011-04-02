require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module PredicatePropogating #:nodoc:

    def gen_assert(parser, scope={})
      propogate_gen parser.child, :assert, scope
    end

    def gen_disallow(parser, scope={})
      propogate_gen parser.child, :disallow, scope
    end

    def gen_intermediate_assert(parser, scope={})
      propogate_gen parser.child, :intermediate_assert, scope
    end

    def gen_intermediate_disallow(parser, scope={})
      propogate_gen parser.child, :intermediate_disallow, scope
    end

  end
end
