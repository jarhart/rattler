require 'rattler/parsers'

module Rattler::Parsers
  #
  # +SemanticDisallow+ peforms a symantic action by evaluating ruby code and
  # succeeds with no parse result if the code evaluates to a false value.
  #
  # @author Jason Arhart
  #
  class SemanticDisallow < DirectAction

    protected

    def create_bindable_code
      DisallowCode.new(code)
    end

    class MyCode < ActionCode
      def bind(scope, bind_args)
        "!(#{super})"
      end
    end

  end
end
