#
# = rattler/parsers/atomic.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

module Rattler::Parsers
  # @private
  module Atomic #:nodoc:

    # @param (see Parser#with_ws)
    # @return (see Parser#with_ws)
    def with_ws(ws)
      ws.skip & self
    end

  end
end
