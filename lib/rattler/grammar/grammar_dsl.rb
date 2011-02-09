#
# = rattler/grammar/grammar_dsl.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/grammar'

module Rattler::Grammar
  # @private
  module GrammarDSL #:nodoc:
    
    def self.included(mod)
      mod.extend ClassMethods
    end
    
    # @private
    module ClassMethods
      
      def start_rule(name)
        define_method(:start_rule) { name }
      end
      
      def grammar(source=nil, &block)
        Rattler.compile(self, source, &block)
      end
      
      def rules(&block)
        Rattler.compile(self, &block)
      end
      
      def rule(name, &block)
        rules { rule(name) {|b| b.instance_exec(&block) } }
      end
      
      def token(name, &block)
        rules { token(name) {|b| b.instance_exec(&block) } }
      end
      
      def with_options(options, &block)
        rules { with_options(options, &block) }
      end
      
      def with_ws(ws, &block)
        rules { with_ws(ws, &block) }
      end
      
    end
    
  end
end
