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
    
    def self.parsed(results, *_)
      self[results.first]
    end
    
    def capturing?
      false
    end
    
    def with_ws(ws)
      self.class.new(child.with_ws(ws), attrs)
    end
    
    def token_optimized
      optimized
    end
    
    def skip_optimized
      optimized
    end
    
  end
end
