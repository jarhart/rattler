#
# = rattler/parsers/eof.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'
require 'singleton'

module Rattler::Parsers
  #
  # +Eof+ succeeds if there is no more input to parse.
  #
  # @author Jason Arhart
  #
  class Eof < Predicate
    include Singleton
    
    # Return the singleton instance of +Eof+
    #
    # @return [Eof] the singleton instance
    def self.[]()
      self.instance
    end
    
    # @private
    def self.parsed(*_) #:nodoc:
      self.instance
    end
    
    # Return +true+ if there is no more input to parse
    #
    # @param (see Parser#parse_labeled)
    #
    # @return true if there is no more input to parse
    def parse(scanner, rules, labeled = {})
      scanner.eos?
    end
    
    # Return a new parser that uses +ws+ to skip whitespace before matching.
    #
    # @param (see Parser#with_ws)
    # @return (see Parser#with_ws)
    def with_ws(ws)
      Skip[ws] & self
    end
    
  end
end
