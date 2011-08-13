require 'rattler/parsers'

module Rattler::Parsers
  # @private
  module Semantic #:nodoc:

    def bind(scope, bind_args)
      bindable_code.bind(scope, bind_args)
    end

    def bindable_code
      @bindable_code ||= create_bindable_code
    end

  end
end
