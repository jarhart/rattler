require 'rattler/util'

module Rattler::Util

  # +GraphViz+ provides utilities to build GraphViz objects representing trees
  # of nodes.
  module GraphViz

    autoload :DigraphBuilder, 'rattler/util/graphviz/digraph_builder'
    autoload :NodeBuilder, 'rattler/util/graphviz/node_builder'

    # (see DigraphBuilder.digraph)
    def self.digraph(root, name='G')
      DigraphBuilder.digraph(root, name)
    end

  end
end
