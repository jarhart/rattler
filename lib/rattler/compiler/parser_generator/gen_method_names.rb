require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator

  # @private
  GEN_METHOD_TYPES = %w{
    basic
    assert
    disallow
    token
    skip
    intermediate
    intermediate_assert
    intermediate_disallow
    intermediate_skip
  }

  @private
  GEN_METHOD_NAMES = GEN_METHOD_TYPES.map {|_| :"gen_#{_}" }

end
