require 'rattler/parsers'

module Rattler::Parsers
  module Sequencing
    include Combining

    def sequence?
      true
    end

    protected

    def backtracking(scanner)
      pos = scanner.pos
      yield or begin
        scanner.pos = pos
        false
      end
    end

    def parse_children(scanner, rules, scope)
      for child in children
        if r = child.parse(scanner, rules, scope) {|_| scope = scope.merge _ }
          scope = scope.capture(r) unless r == true
          yield r if block_given?
        else
          return false
        end
      end
      scope
    end

  end
end
