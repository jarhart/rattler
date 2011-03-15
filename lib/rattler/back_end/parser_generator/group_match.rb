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

    def parse(scanner, rules, scope={})
      scanner.scan(re) && if num_groups == 1
        scanner[1]
      else
        (1..num_groups).map {|_| scanner[_] }
      end
    end

  end
end
