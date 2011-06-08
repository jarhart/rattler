#
# = rattler/util/graphviz/node_builder.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/util/graphviz'

module Rattler::Util::GraphViz
  #
  # +NodeBuilder+ is used by +DigraphBuilder+ to build nodes for a GraphViz
  # digraph object representing a tree of nodes.
  #
  # @author Jason Arhart
  #
  class NodeBuilder

    # Yield any children of +o+ that should be represented as separate nodes in
    # the graph.
    def each_child_of(o)
      if array_like? o and not record_like? o
        if o.respond_to? :to_hash
          o.each {|k, v| yield Mapping.new(k, v) }
        else
          o.each {|_| yield _ }
        end
      end
    end

    # Return the options for a node representing +o+.
    # @return the options for a node representing +o+.
    def node_options(o)
      { :shape => node_shape(o), :label => node_label(o) }
    end

    # Return the shape option for a node representing +o+.
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

    # Return the label option for a node representing +o+.
    # @return the label option for a node representing +o+.
    def node_label(o)
      if o.is_a? ::Rattler::Util::Node
        record_label(o, parse_node_fields(o.attrs))
      elsif record_like? o
        record_label(o, o)
      elsif array_like? o
        type_label(o)
      elsif o.respond_to? :to_str
        "\"#{o}\""
      else
        o.inspect
      end
    end

    def type_label(o)
      case o
      when Hash then '\\{\\}'
      when Array then '\\[\\]'
      when Mapping then '-&gt;'
      else o.respond_to?(:name) ? o.name : o.class.name
      end
    end

    def array_like?(o)
      o.respond_to? :each and
      not o.respond_to? :to_str
    end

    def record_like?(o)
      o.respond_to? :each_pair and
      o.none? {|k, v| array_like? v or record_like? v }
    end

    def record_label(o, fields)
      '{' + ([type_label(o)] + hash_content_labels(fields)).join('|') + '}'
    end

    def hash_content_labels(h)
      h.map {|pair| '{' + pair.map {|_| _.inspect }.join('|') + '}' }
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

  end
end
