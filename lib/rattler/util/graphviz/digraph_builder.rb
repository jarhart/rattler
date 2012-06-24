begin
  require 'graphviz'
rescue LoadError => e
  abort "I need the ruby-graphviz gem and GraphViz installed and in the PATH.\n"
end

require 'rattler/util/graphviz'

module Rattler::Util::GraphViz

  # +DigraphBuilder+ is used to build GraphViz objects representing trees of
  # nodes.
  class DigraphBuilder
    include NodeBuilder

    # @param (see #initialize)
    # @return a new +GraphViz+ digraph object representing +root+
    def self.digraph(root, name='G')
      self.new(root, name).digraph
    end

    # Create a new digraph builder for +root+.
    #
    # @param root the root node
    # @param [String] name the name of the graph
    def initialize(root, name='G')
      @root = root
      @g = ::GraphViz.digraph(name)
      @nodes = {}
      @node_serial = 0
    end

    # @return a new +GraphViz+ digraph object representing the root object
    def digraph
      @digraph ||= begin
        node(@root)
        @g
      end
    end

    # Return a <tt>GraphViz::Node</tt> object for +o+. Multiple requests with
    # the same object return the same node object.
    #
    # @param o an object
    # @return [GraphViz::Node] a node object for +o+
    def node(o)
      @nodes.fetch(o.object_id) do
        new_node = @g.add_nodes new_node_name, node_options(o)
        @nodes[o.object_id] = new_node
        each_child_node_of(o) {|_| new_node << node(_) }
        new_node
      end
    end

    private

    def new_node_name
      name = "n#{@node_serial}"
      @node_serial += 1
      name
    end

  end
end
