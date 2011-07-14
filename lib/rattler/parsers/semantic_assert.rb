require 'rattler/parsers'

module Rattler::Parsers
  #
  # +SemanticAssert+ decorates a parser to peform a symantic action on success
  # by evaluating ruby code and succeed if the result is a true value.
  #
  # @author Jason Arhart
  #
  class SemanticAssert < DirectAction

    protected

    def create_bindable_code
      AssertCode.new(code)
    end

  end
end
