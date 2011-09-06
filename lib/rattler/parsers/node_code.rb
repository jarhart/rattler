require 'rattler/parsers'

module Rattler::Parsers
  # @private
  class NodeCode #:nodoc:

    def initialize(node_type, factory_method, node_attrs)
      @node_type = node_type
      @factory_method = factory_method
      @node_attrs = node_attrs
    end

    attr_reader :node_type, :factory_method, :node_attrs

    def bind(scope)
      "#{node_type}.#{factory_method}(#{args_expr scope})"
    end

    def args_expr(scope)
      args = [captures_expr(scope)]
      attrs = encoded_binding_attrs(scope).merge encoded_node_attrs(scope)
      args << encode_assocs(attrs) unless attrs.empty?
      args.join(', ')
    end

    def captures_expr(scope)
      expr = '[' + scope.captures.join(', ') + ']'
      scope.captures_decidable? ? expr : "select_captures(#{expr})"
    end

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
