require 'rattler/parsers'

module Rattler::Parsers

  # +Sequence+ combines two or more parsers and matches by trying each one in
  # sequence and failing unless they all succeed.
  class Sequence < Parser
    include Sequencing

    # @private
    def self.parsed(results, *_) #:nodoc:
      results.reduce(:&)
    end

    # Try each parser in sequence, and if they all succeed return an array of
    # captured results, or return +false+ if any parser fails.
    #
    # @param (see Match#parse)
    #
    # @return an array of captured results of each parser in sequence, or
    #   +false+
    def parse(scanner, rules, scope = ParserScope.empty)
      backtracking(scanner) do
        if scope = parse_children(scanner, rules, scope.nest)
          yield scope if block_given?
          parse_result(scope)
        end
      end
    end

    # (see Parser#&)
    def &(other)
      Sequence[(children + [other])]
    end

    # (see Parser#>>)
    def >>(semantic)
      AttributedSequence[(children + [semantic])]
    end

    # @return [Fixnum] the number of child parsers that are capturing
    def capture_count
      @capture_count ||= count {|_| _.capturing? }
    end

    private

    def parse_result(scope)
      case capture_count
      when 0 then true
      when 1 then scope.captures[0]
      else scope.captures
      end
    end

  end
end
