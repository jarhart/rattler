#
# = rattler/parsers/assert_code.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  # @private
  class AssertCode < ActionCode #:nodoc:

    def bind(scope, bind_args)
      "(#{super}) && true"
    end

  end
end
