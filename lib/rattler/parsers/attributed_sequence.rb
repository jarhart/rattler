require 'rattler/parsers'

module Rattler::Parsers
  class AttributedSequence < Parser
    include Sequencing

    # @private
    def self.parsed(results, *_) #:nodoc:
      op, action = results
      (op + [action]).reduce(:>>)
    end

    def parse(scanner, rules, scope = ParserScope.empty)
      result = false
      backtracking(scanner) do
        if scope = parse_children(scanner, rules, scope.nest) {|r| result = r }
          yield scope if block_given?
          result
        end
      end
    end

    def capturing?
      children.last.capturing?
    end

    def capturing_decidable?
      false
    end

    def capture_count
      @capture_count ||= children[0...-1].count {|_| _.capturing? }
    end

  end
end
