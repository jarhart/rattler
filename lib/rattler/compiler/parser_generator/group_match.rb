require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator
  # @private
  class GroupMatch < Rattler::Parsers::Parser #:nodoc:

    alias_method :match, :child

    def re
      match.re
    end

    def capture_count
      num_groups
    end

    def parse(scanner, rules, scope = ParserScope.empty)
      scanner.scan(re) && if num_groups == 1
        yield scope.nest.capture(scanner[1]) if block_given?
        scanner[1]
      else
        rs = (1..num_groups).map {|_| scanner[_] }
        yield scope.nest.capture(*rs) if block_given?
        rs
      end
    end

    def sequence?
      num_groups > 1
    end

  end
end
