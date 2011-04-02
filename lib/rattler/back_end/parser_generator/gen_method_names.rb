require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  GEN_METHOD_TYPES = %w{
    basic
    assert
    disallow
    dispatch_action
    direct_action
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
