#
# = rattler/parsers/disallow_code.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  # @private
  class DisallowCode < ActionCode #:nodoc:

    def bind(scope, bind_args)
      "!(#{super})"
    end

  end
end
