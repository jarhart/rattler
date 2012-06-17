module Rattler::Parsers

  # +NodeAction+ is a pseudo-parser that creates a parse node object from
  # captured parse results
  class NodeAction < Parser
    include Semantic

    DEFAULT_NODE_TYPE = 'Rattler::Runtime::ParseNode'
    DEFAULT_FACTORY_METHOD = :parsed

    # @private
    def self.parsed(results, *_) #:nodoc:
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

    # @param [String,Symbol] node_type the name of the class to instantiate
    #   nodes from
    # @param [Hash] attrs attributes defining how to instantiate the node
    # @option attrs [Hash] :node_attrs ({}) attributes to add to new parse
    #   nodes
    # @option attrs [Strin,Symbol] :method (:parsed) the class method used to
    #   create new parse nodes
    # @return [NodeAction] a pseudo-parser that creates parse nodes
    def self.[](node_type, attrs={})
      self.new(attrs.merge :node_type => node_type)
    end

    # @return [Symbol] the name of the class to instantiate nodes from
    def node_type
      (attrs[:node_type] || DEFAULT_NODE_TYPE).to_sym
    end

    # @return [Hash] attributes to add to the instantiated node
    def node_attrs
      attrs[:node_attrs] || {}
    end

    # @return [Symbol] the class method used to create new parse nodes
    def factory_method
      (attrs[:method] || DEFAULT_FACTORY_METHOD).to_sym
    end

    # Create a new parse node from parse results in +scope+
    #
    # @param (see Match#parse)
    #
    # @return a new parse node created from parse results in +scope+
    def parse(scanner, rules, scope = ParserScope.empty)
      apply scope
    end

    protected

    # @return [NodeCode] an object that be bound to a parser scope to return
    #   ruby code that creates a new node
    def create_bindable_code
      NodeCode.new(node_type, factory_method, node_attrs)
    end

  end
end
