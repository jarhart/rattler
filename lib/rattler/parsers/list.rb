#
# = rattler/parsers/list.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +List+ matches terms matched by a term parser in a list with separators
  # matched by a separator parser.  +List+ always matches even if there are no
  # matched terms.
  #
  # @author Jason Arhart
  #
  class List < ListParser
    protected

    def enough?(results)
      true
    end

  end
end
