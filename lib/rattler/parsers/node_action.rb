module Rattler::Parsers
  class NodeAction < Parser
    include Semantic

    DEFAULT_NODE_TYPE = 'Rattler::Runtime::ParseNode'
    DEFAULT_FACTORY_METHOD = :parsed

    def self.parsed(results, *_)
      optional_node_def, optional_name = results
      attrs = {}
      unless optional_name.empty?
        attrs[:node_attrs] = {:name => eval(optional_name[0], TOPLEVEL_BINDING)}
      end
      if optional_node_def.empty?
        self[DEFAULT_NODE_TYPE, attrs]
      else
        node_type, optional_method = optional_node_def[0]
        attrs[:method] = optional_method[0] unless optional_method.empty?
        self[node_type, attrs]
      end
    end

    def self.[](node_type, attrs={})
      self.new(attrs.merge :node_type => node_type)
    end

    def node_type
      (attrs[:node_type] || DEFAULT_NODE_TYPE).to_sym
    end

    def node_attrs
      attrs[:node_attrs] || {}
    end

    def factory_method
      attrs[:method] || DEFAULT_FACTORY_METHOD
    end

    def parse(scanner, rules, scope = ParserScope.empty)
      apply scope
    end

    protected

    def binding_attrs(scope)
      scope.bindings.empty? ? {} : { :labeled => scope.bindings }
    end

    def create_bindable_code
      NodeCode.new(node_type, factory_method, node_attrs)
    end

  end
end
