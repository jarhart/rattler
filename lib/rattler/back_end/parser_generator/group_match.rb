require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  class GroupMatch < Rattler::Parsers::Parser #:nodoc:

    alias_method :match, :child

    def re
      match.re
    end

    def capture_count
      num_groups
    end

  end
end
