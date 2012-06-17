module Rattler::Parsers

  # +Atomic+ describes a parser that is not a combination of other parsers.
  module Atomic #:nodoc:

    # (see Parser#with_ws)
    def with_ws(ws)
      ws.skip & self
    end

  end
end
