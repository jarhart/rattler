#
# = rattler/parsers/list1.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +List1+ matches terms matched by a term parser in a list with separators
  # matched by a separator parser. +List1+ fails unless at least one term is
  # matched.
  #
  # @author Jason Arhart
  #
  class List1 < ListParser
    protected

    def enough?(results)
      not results.empty?
    end

  end
end
