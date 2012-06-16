require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator
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
