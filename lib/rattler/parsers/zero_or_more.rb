#
# = rattler/parsers/zero_or_more.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +ZeroOrMore+ decorates a parser to match repeatedly and always succeed.
  #
  # @author Jason Arhart
  #
  class ZeroOrMore < Parser
    include Combining
    
    # Parse using the decorated parser as many times as it succeeds. Return the
    # results in an array, or +true+ if the decorated parser is not
    # <tt>capturing?</tt>.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return [Array, true] an array containing the decorated parser's parse
    #   returns, or +true+ if the decorated parser is not <tt>capturing?</tt>
    def parse(scanner, rules, labeled = {})
      a = []
      while result = child.parse(scanner, rules)
        a << result
      end
      capturing? ? a : true
    end
    
    def variable_capture_count?
      true
    end
    
    # @private
    def token_optimized #:nodoc:
      to = super
      if Match === to.child
        to.child.re_zero_or_more
      else
        to
      end
    end
    
    # @private
    def skip_optimized #:nodoc:
      so = super
      if Match === so.child
        so.child.re_zero_or_more
      else
        so
      end
    end
    
  end
end
