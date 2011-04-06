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
    # @param (see Parser#parse_labeled)
    #
    # @return true if there is no more input to parse
    def parse(scanner, rules, scope = {})
      scanner.eos?
    end

  end
end
