require 'rattler/parsers'

module Rattler::Parsers

  # +Semantic+ describes parsers that perform a semantic action
  module Semantic

    # @param [ParserScope] scope the scope of captures to bind in the code
    # @return [String] ruby code that performs the action
    def bind(scope)
      bindable_code.bind(scope)
    end

    # @return an object that be bound to a parser scope to return ruby code
    #   that performs the action
    def bindable_code
      @bindable_code ||= create_bindable_code
    end

    # @return +true+
    def semantic?
      true
    end

    private

    def apply(scope)
      code_bindings = {}
      scope.each_binding {|k, v| code_bindings[k] = v.inspect }
      code_captures = scope.captures.map {|_| _.inspect }
      code_scope = ParserScope.new(code_bindings, code_captures)
      eval(bind(code_scope))
    end

  end
end
