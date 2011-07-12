require 'rattler/parsers'

module Rattler::Parsers
  #
  # +SideEffect+ decorates a parser to peform a symantic action on success by
  # evaluating ruby code for effect and discarding the result.
  #
  # @author Jason Arhart
  #
  class SideEffect < DirectAction

    def capturing?
      false
    end

    protected

    def create_bindable_code
      EffectCode.new(code)
    end

  end
end
