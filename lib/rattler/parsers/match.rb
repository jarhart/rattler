#
# = rattler/parsers/match.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +Match+ parses by matching with a +Regexp+. If the +Regexp+ matches at
  # the parse position the entire matched string is returned, otherwise the
  # parse fails.
  #
  # @author Jason Arhart
  #
  class Match < Parser
    
    # Create a new parser that matches with +re+.
    #
    # @param [Regexp] re the pattern to match
    #
    # @return [Match] a new match parser that matches with +re+
    #
    def self.[](re)
      self.new(:re => re)
    end
    
    # @private
    def self.parsed(results, *_) #:nodoc:
      self[eval(results.first)]
    end
    
    # If the +Regexp+ matches at the parse position, return the matched
    # string, otherwise return a false value.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return the matched string, or +nil+
    def parse(scanner, rules, labeled = {})
      scanner.scan re
    end
    
    # @param (see Parser#with_ws)
    # @return (see Parser#with_ws)
    def with_ws(ws)
      Skip[ws] & self
    end
    
    # @private
    def re_optional #:nodoc:
      Match[/#{atomic_re.source}?/]
    end
    
    # @private
    def re_zero_or_more #:nodoc:
      Match[/#{atomic_re.source}*/]
    end
    
    # @private
    def re_one_or_more #:nodoc:
      Match[/#{atomic_re.source}+/]
    end
    
    # @private
    def assert_re #:nodoc:
      /(?=#{re.source})/
    end
    
    # @private
    def disallow_re #:nodoc:
      /(?!#{re.source})/
    end
    
    # @private
    def atomic_re #:nodoc:
      /(?>#{re.source})/
    end
    
    # @private
    def as_match #:nodoc:
      self
    end
    
  end
end
