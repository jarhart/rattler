require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
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
