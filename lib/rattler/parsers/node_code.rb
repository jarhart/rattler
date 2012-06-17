require 'rattler/parsers'

module Rattler::Parsers

  # +NodeCode+ defines a set of attributes that can be found to captured parse
  # returns to produce ruby code that creates a new node from the parse results.
  class NodeCode #:nodoc:

    # @param [Symbol] node_type the name of the class to instantiate nodes from
    # @param [Symbol] factory_method the class method used to create new parse
    #   nodes
    # @param [Hash] node_attrs attributes to add to new parse nodes
    def initialize(node_type, factory_method, node_attrs)
      @node_type = node_type
      @factory_method = factory_method
      @node_attrs = node_attrs
    end

    attr_reader :node_type, :factory_method, :node_attrs

    # @param [ParserScope] scope the scope of captured parse results
    # @return [String] ruby code that creates a new node from the parse results
    def bind(scope)
      "#{node_type}.#{factory_method}(#{args_expr scope})"
    end

    # @param [ParserScope] scope the scope of captured parse results
    # @return [String] ruby code for the arguments to the node factory method
    def args_expr(scope)
      args = [captures_expr(scope)]
      attrs = encoded_binding_attrs(scope).merge encoded_node_attrs(scope)
      args << encode_assocs(attrs) unless attrs.empty?
      args.join(', ')
    end

    # @param [ParserScope] scope the scope of captured parse results
    # @return [String] ruby code for the captures argument to the node factory
    #   method
    def captures_expr(scope)
      expr = '[' + scope.captures.join(', ') + ']'
      scope.captures_decidable? ? expr : "select_captures(#{expr})"
    end

    private

    def encoded_binding_attrs(scope)
      scope.bindings.empty? ? {} : { :labeled => encode_hash(scope.bindings) }
    end

    def encoded_node_attrs(scope)
      node_attrs.map {|k, v| {k => v.inspect} }.inject({}, &:merge)
    end

    def encode_hash(h)
      "{#{encode_assocs h}}"
    end

    def encode_assocs(h)
      h.map {|k, v| ":#{k} => #{v}" }.join(', ')
    end

  end
end
