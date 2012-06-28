module Rattler::Parsers

  # +Combining+ describes a parser that is a combination of other parsers.
  module Combining

    # (see Parser#capturing?)
    def capturing?
      @capturing ||= any? {|child| child.capturing? }
    end

    # (see Parser#capturing_decidable?)
    def capturing_decidable?
      @capturing_decidable ||= all? {|child| child.capturing_decidable? }
    end

    # (see Parser#semantic?)
    def semantic?
      @semantic = any? {|child| child.semantic? }
    end

    # (see Parser#with_ws)
    def with_ws(ws)
      self.class.new(children.map {|_| _.with_ws(ws) }, attrs)
    end

  end
end
