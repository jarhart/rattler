#
# = rattler/parsers/choice.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +Choice+ combines two or more parsers and matches by trying each one in
  # order until one succeeds and returning that result.
  #
  # @author Jason Arhart
  #
  class Choice < Parser
    include Combining
    include MatchJoining
    
    # @private
    def self.parsed(results, *_) #:nodoc:
      results.reduce(:|)
    end
    
    # Try each parser in order until one succeeds and return that result.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return the result of the first parser that matches, or +false+
    def parse(scanner, rules, labeled = {})
      for child in children
        if r = child.parse_labeled(scanner, rules, labeled)
          return r
        end
      end
      false
    end
    
    # Return a new parser that tries this parser first and if it fails tries
    # +other+.
    #
    # @param other (see Parser#|)
    # @return (see Parser#|)
    def |(other)
      Choice[(children + [other])]
    end
    
    protected
    
    def optimized_children
      join_matches super
    end
    
    def token_optimized_children
      join_matches super
    end
    
    def skip_optimized_children
      join_matches super
    end
    
    def match_join(matches)
      matches.map {|_| _.re.source }.join('|')
    end
    
    def join_matches(parsers)
      super flatten_choices(parsers)
    end
    
    private
    
    def flatten_choices(parsers)
      if parsers.all? {|_| Choice === _ }
        parsers.map {|_| _.to_a }.reduce(:+)
      else
        parsers
      end
    end
    
  end
end
