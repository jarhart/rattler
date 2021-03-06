require 'rattler/parsers'

module Rattler::Parsers

  # +Disallow+ decorates a parser and succeeds if the decorated parser fails
  # and fails if the parser succeeds and never consumes any input (zero-width
  # negative lookahead).
  class Disallow < Predicate

    # Succeed and return +true+ if and only if decorated parser fails. Never
    # consumes any input.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return [Boolean] +true+ if the decorated parser fails
    def parse(scanner, rules, scope = ParserScope.empty)
      pos = scanner.pos
      result = !child.parse(scanner, rules, scope)
      scanner.pos = pos
      result
    end

  end
end
