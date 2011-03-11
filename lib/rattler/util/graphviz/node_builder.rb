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
      o.each {|_| yield _ } if array_like? o and not record_like? o
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
      when Hash, Array
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
        record_label(o, o.attrs)
      elsif record_like? o
        record_label(o, o)
      elsif array_like? o
        type_label(o)
      else
        o.inspect
      end
    end

    def type_label(o)
      case o
      when Hash then '\\{\\}'
      when Array then '\\[\\]'
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

    def record_label(o, h)
      '{' + ([type_label(o)] + hash_content_labels(h)).join('|') + '}'
    end

    def hash_content_labels(h)
      h.map {|pair| '{' + pair.map {|_| _.inspect }.join('|') + '}' }
    end

  end
end
