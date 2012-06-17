require 'rattler/parsers'

module Rattler::Parsers

  # +Sequencing+ describes a parser that combines two or more parsers and
  # matches in sequence.
  module Sequencing
    include Combining

    # @return +true+
    def sequence?
      true
    end

    protected

    # @private
    def backtracking(scanner) #:nodoc:
      pos = scanner.pos
      yield or begin
        scanner.pos = pos
        false
      end
    end

    # @private
    def parse_children(scanner, rules, scope) #:nodoc:
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
