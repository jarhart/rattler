require 'rattler/parsers'

module Rattler::Parsers
  #
  # +SemanticAssert+ peforms a symantic action by evaluating ruby code and
  # succeeds with no parse result if the code evaluates to a true value.
  #
  # @author Jason Arhart
  #
  class SemanticAssert < DirectAction

    protected

    def create_bindable_code
      AssertCode.new(code)
    end

    class MyCode < ActionCode
      def bind(scope, bind_args)
        "(#{super}) && true"
      end
    end

  end
end
