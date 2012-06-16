require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator
  # @private
  module Nested #:nodoc:

    def expr(type=:inline)
      if type == :inline
        @g.surround('(', ')') { yield }
      else
        @g.block('begin') { yield }
      end
    end

    def nested?
      true
    end

  end
end
