#
# = rattler/parsers/combining.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

module Rattler::Parsers
  # @private
  module Combining #:nodoc:

    def capturing?
      @capturing ||= any? {|child| child.capturing? }
    end

    def semantic?
      @semantic = any? {|child| child.semantic? }
    end

    def with_ws(ws)
      self.class.new(children.map {|_| _.with_ws(ws) }, attrs)
    end

  end
end
