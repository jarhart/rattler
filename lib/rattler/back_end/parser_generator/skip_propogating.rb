require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module SkipPropogating #:nodoc:

    def gen_skip(parser)
      generate parser.child, :skip
    end

    def gen_intermediate_skip(parser)
      generate parser.child, :intermediate_skip
    end

  end
end
