#
# = rattler/parsers/sequence.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +Sequence+ combines two or more parsers and matches by trying each one in
  # sequence and failing unless they all succeed.
  #
  # @author Jason Arhart
  #
  class Sequence < Parser
    include Combining

    # @private
    def self.parsed(results, *_) #:nodoc:
      results.reduce(:&)
    end

    # Try each parser in sequence, and if they all succeed return an array of
    # captured results, or return +false+ if any parser fails.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return an array of captured results of each parser in sequence, or
    #   +false+
    def parse(scanner, rules, scope = ParserScope.empty)
      scope = scope.nest
      pos = scanner.pos
      for child in children
        if r = child.parse(scanner, rules, scope) {|_| scope = scope.merge _ }
          scope = scope.capture(r) unless r == true
        else
          scanner.pos = pos
          return false
        end
      end
      yield scope if block_given?
      case capture_count
      when 0 then true
      when 1 then scope.captures[0]
      else scope.captures
      end
    end

    # Return a new parser that tries both this parser and +other+ and fails
    # unless both parse in sequence.
    #
    # @param other (see Parser#&)
    # @return (see Parser#&)
    def &(other)
      Sequence[(children + [other])]
    end

    # The number of child parsers that are capturing
    #
    # @return the number of child parsers that are capturing
    def capture_count
      @capture_count ||= count {|_| _.capturing? }
    end

  end
end
