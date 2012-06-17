require 'rattler/parsers'
require 'singleton'

module Rattler::Parsers

  # +ESymbol+ always succeeds without advancing.
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
    # @param (see Match#parse)
    #
    # @return [Boolean] +true+
    def parse(*_)
      true
    end

    # (see Parser#capturing?)
    def capturing?
      false
    end

  end
end
