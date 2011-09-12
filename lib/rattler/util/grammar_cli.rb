require 'rattler/util'

module Rattler::Util
  class GrammarCLI < ParserCLI

    def self.run(grammar_module)
      self.new(grammar_module).run
    end

    def initialize(grammar_module)
      parser_class = Class.new(Rattler::Runtime::ExtendedPackratParser)
      parser_class.module_eval { include grammar_module }
      super(parser_class)
    end

  end
end
