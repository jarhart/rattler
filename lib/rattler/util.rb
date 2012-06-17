require 'rattler'

module Rattler
  # Utility classes
  module Util
    autoload :LineCounter, 'rattler/util/line_counter'
    autoload :Node, 'rattler/util/node'
    autoload :ParserSpecHelper, 'rattler/util/parser_spec_helper'
    autoload :ParserCLI, 'rattler/util/parser_cli'
    autoload :GrammarCLI, 'rattler/util/grammar_cli'
    autoload :GraphViz, 'rattler/util/graphviz'
  end
end
