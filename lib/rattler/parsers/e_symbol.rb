#
# = rattler/parsers/e_symbol.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'
require 'singleton'

module Rattler::Parsers
  #
  # +ESymbol+ always succeeds without advancing.
  #
  # @author Jason Arhart
  #
  class ESymbol < Parser
    include Atomic
    include Singleton

    # Return the singleton instance of +ESymbol+
    #
    # @return [ESymbol] the singleton instance
    def self.[]()
      self.instance
    end

    # @private
    def self.parsed(*_) #:nodoc:
      self.instance
    end

    # Return +true+ without advancing
    #
    # @param (see Parser#parse)
    #
    # @return true
    def parse(scanner, rules, scope = {})
      true
    end

    def capturing?
      false
    end

  end
end
