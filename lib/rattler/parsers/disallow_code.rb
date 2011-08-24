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

    def bind(scope)
      "!(#{super}) && #{result_code scope.captures}"
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