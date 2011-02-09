#
# = rattler/runtime/parser_helper.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/runtime'

module Rattler::Runtime
  # @private
  module ParserHelper #:nodoc:
    
    def select_captures(results)
      results.reject {|_| _ == true }
    end
    
  end
end
