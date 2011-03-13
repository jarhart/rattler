require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module SkipPropogating #:nodoc:

    def gen_skip(parser, scope={})
      generate parser.child, :skip, scope
    end

    def gen_intermediate_skip(parser, scope={})
      generate parser.child, :intermediate_skip, scope
    end

  end
end
