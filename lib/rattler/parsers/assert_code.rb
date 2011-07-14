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
      "(#{super}) && #{result_code bind_args}"
    end

    private

    def result_code(bind_args)
      if bind_args.size > 1
        '[' + bind_args.join(', ') + ']'
      elsif bind_args.size == 1
        bind_args.first
      else
        'true'
      end
    end

  end
end
