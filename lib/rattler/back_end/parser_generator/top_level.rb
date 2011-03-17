require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module TopLevel #:nodoc:

    def expr(type=:inline)
      yield
    end

    def nested?
      false
    end

  end
end
