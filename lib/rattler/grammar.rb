#
# = rattler/grammar.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler'

module Rattler
  #
  # The +Grammar+ module defines the grammar parser
  #
  # @author Jason Arhart
  #
  module Grammar
    autoload :Grammar, 'rattler/grammar/grammar'
    autoload :GrammarParser, 'rattler/grammar/grammar_parser'
    autoload :GrammarDSL, 'rattler/grammar/grammar_dsl'
    autoload :Metagrammar, 'rattler/grammar/metagrammar'
    
    # Parse +source+ as a grammar and raise a {Rattler::Runtime::SyntaxError}
    # if the parse fails.
    #
    # @param (see Rattler::RecursiveDescentParser#initialize)
    # @raise (see Rattler::RecursiveDescentParser#parse!)
    #
    # @return [Grammar] the parsed grammar
    def self.parse!(source, options={})
      GrammarParser.parse!(source, options={})
    end
    
    # Parse +source+ as a grammar.
    #
    # @param (see Rattler::RecursiveDescentParser#initialize)
    #
    # @return [Grammar] the parsed grammar
    def self.parser(source, options={})
      GrammarParser.new(source, options={})
    end
    
  end
end
