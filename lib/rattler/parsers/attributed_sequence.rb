require 'rattler/parsers'

module Rattler::Parsers

  # +AttributedSequence+ combines one or more parsers with a semantic action
  # and matches the parser in sequence and applies the action to the captured
  # results.
  class AttributedSequence < Parser
    include Sequencing

    # @private
    def self.parsed(results, *_) #:nodoc:
      op, action = results
      (op + [action]).reduce(:>>)
    end

    # Parse each parser in sequence, and if they all succeed return the result
    # of applying the semantic action to the captured results.
    #
    # @param (see Match#parse)
    #
    # @return the result of applying the semantic action to the captured
    #   results of each parser, or +false
    def parse(scanner, rules, scope = ParserScope.empty)
      result = false
      backtracking(scanner) do
        if scope = parse_children(scanner, rules, scope.nest) {|r| result = r }
          yield scope if block_given?
          result
        end
      end
    end

    # (see Parser#capturing?)
    def capturing?
      children.last.capturing?
    end

    # (see Parser#capturing_decidable?)
    def capturing_decidable?
      false
    end

    # (see Sequence#capture_count)
    def capture_count
      @capture_count ||= children[0...-1].count {|_| _.capturing? }
    end

  end
end
