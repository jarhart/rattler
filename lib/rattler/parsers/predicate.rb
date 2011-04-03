#
# = rattler/parsers/predicate.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  # @private
  class Predicate < Parser #:nodoc:
    include Combining

    def self.parsed(results, *_)
      self[results.first]
    end

    def capturing?
      false
    end

  end
end
