#
# = rattler/util/graphviz.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/util'

module Rattler::Util
  #
  # The +GraphViz+ provides utilities to build GraphViz objects representing
  # trees of nodes.
  #
  # @author Jason Arhart
  #
  module GraphViz

    autoload :DigraphBuilder, 'rattler/util/graphviz/digraph_builder'
    autoload :NodeBuilder, 'rattler/util/graphviz/node_builder'

    # Return a new +GraphViz+ digraph object representing +root+.
    #
    # @return a new +GraphViz+ digraph object representing +root+
    def self.digraph(root)
      DigraphBuilder.digraph(root)
    end

  end
end
