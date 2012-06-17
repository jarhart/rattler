require 'rattler/parsers'

module Rattler::Parsers

  # A +Predicate+ is a parser that either succeeds or fails and never consumes
  # any input or captures any parse results.
  class Predicate < Parser
    include Combining

    # @private
    def self.parsed(results, *_) #:nodoc:
      self[results.first]
    end

    # (see Parser#capturing?)
    def capturing?
      false
    end

  end
end
