require 'rattler/runtime'

module Rattler::Runtime
  # @private
  module ParserHelper #:nodoc:

    def select_captures(results)
      results.reject {|_| _.equal? true }
    end

  end
end
