#
# = rattler/parsers/label.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +Label+ decorates a parser and associates a label with the decorated
  # parser's parse result if successful. The label only applies if nested in a
  # +Choice+ or +Sequence+ decorated by an +Action+.
  #
  # @author Jason Arhart
  #
  class Label < Parser
    include Combining

    # @private
    def self.parsed(results, *_) #:nodoc:
      self[*results]
    end

    # Create a new parser that decorates +parser+ and associates +label+ with
    # +parser+'s parse result on success.
    def self.[](label, parser)
      self.new(parser, :label => label.to_sym)
    end

    # Always +true+
    # @return true
    def labeled?
      true
    end

    # Delegate to the decorated parser and associate #label with the parse
    # result if successful.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return the decorated parser's parse result
    def parse(scanner, rules, scope = {})
      if result = child.parse(scanner, rules, scope) {|_| scope = _ }
        yield scope.merge(label => result) if block_given?
        result
      end
    end

  end
end
