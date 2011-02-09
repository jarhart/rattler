require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module TopLevel #:nodoc:
    def self.included(m)
      for name in GEN_METHOD_NAMES
        unless m.method_defined?(name)
          m.module_eval { alias_method name, :"#{name}_top_level" }
        end
      end
    end
  end
end
