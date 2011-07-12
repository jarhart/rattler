require 'rattler/parsers'

module Rattler::Parsers
  #
  # +SemanticDisallow+ decorates a parser to peform a symantic action on success
  # by evaluating ruby code and succeed if the result is a false value.
  #
  # @author Jason Arhart
  #
  class SemanticDisallow < DirectAction

    def capturing?
      false
    end

    protected

    def create_bindable_code
      DisallowCode.new(code)
    end

  end
end
