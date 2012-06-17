require 'rattler/util'

module Rattler::Util

  # +GrammarCLI+ defines a command line interface for generated grammars.
  class GrammarCLI < ParserCLI

    # Create a new command line interface for the given grammar module
    #
    # @param [Module] grammar_module the grammar module to run the command line
    #   interface for
    def initialize(grammar_module)
      parser_class = Class.new(Rattler::Runtime::ExtendedPackratParser)
      parser_class.module_eval { include grammar_module }
      super(parser_class)
    end

  end
end
