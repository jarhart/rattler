require 'rattler/util/graphviz'

module Rattler::Util::GraphViz

  # +NodeBuilder+ is used by {DigraphBuilder} to build nodes for a GraphViz
  # digraph object representing a tree of nodes.
  module NodeBuilder

    # Run the block with any children of +o+ that should be represented as
    # separate nodes in the graph.
    #
    # @param o an object
    # @yield [child] each child of +o+ that should be represented as a separate
    #   node in the graph
    def each_child_node_of(o)
      if array_like? o and not record_like? o
        if o.respond_to? :to_hash
          o.each {|k, v| yield Mapping.new(k, v) }
        else
          o.each {|_| yield _ }
        end
      end
    end

    # @param o an object
    # @return the options for a node representing +o+.
    def node_options(o)
      { :shape => node_shape(o), :label => node_label(o) }
    end

    # @param o an object
    # @return the shape option for a node representing +o+.
    def node_shape(o)
      case o
      when Array, Hash, Mapping
        'circle'
      when String, Numeric, Symbol
        'plaintext'
      else
        'Mrecord'
      end
    end

    # @param o an object
    # @return the label option for a node representing +o+.
    def node_label(o)
      if o.is_a? ::Rattler::Util::Node
        record_label(o, parse_node_fields(o.attrs))
      elsif record_like? o
        record_label(o, o)
      elsif array_like? o
        type_label(o)
      elsif o.respond_to? :to_str
        string_label(o)
      else
        o.inspect
      end
    end

    # @param o an object
    # @return whether +o+ should be represented as a record
    def record_like?(o)
      o.respond_to? :each_pair and
      o.none? {|k, v| array_like? v or record_like? v }
    end

    # @param o an object
    # @return whether +o+ should be represented as an array
    def array_like?(o)
      o.respond_to? :each and
      not o.respond_to? :to_str
    end

    private

    def string_label(s)
      "\"#{s}\""
    end

    def record_label(o, fields)
      '{' + ([type_label(o)] + hash_content_labels(fields)).join('|') + '}'
    end

    def hash_content_labels(h)
      h.map {|k, v| "{#{k.inspect}|#{record_value v}}" }
    end

    def record_value(v)
      if v.respond_to? :to_str
        string_label(v)
      else
        v.inspect
      end.gsub(/([|<>\\])/) { "\\#{$1}" }
    end

    def type_label(o)
      case o
      when Hash then '\\{\\}'
      when Array then '\\[\\]'
      when Mapping then '-&gt;'
      else o.respond_to?(:name) ? o.name : o.class.name
      end
    end

    def parse_node_fields(attrs)
      attrs.reject {|k,| k == :name || k == :labeled }
    end

    # @private
    class Mapping #:nodoc:
      def initialize(key, value)
        @key = key
        @value = value
      end
      attr_reader :key, :value
      def each
        yield key
        yield value
      end
    end

    extend self
  end
end
