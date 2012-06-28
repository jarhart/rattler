require 'rattler/parsers'
require 'singleton'

module Rattler::Parsers

  # +Eof+ succeeds if there is no more input to parse.
  class Eof < Parser
    include Atomic
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
    # @param (see Match#parse)
    #
    # @return [Boolean] +true+ if there is no more input to parse
    def parse(scanner, *_)
      scanner.eos?
    end

    # (see Parser#capturing?)
    def capturing?
      false
    end

  end
end
