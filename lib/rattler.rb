#
# = rattler.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

# Rattler - Ruby Tool for Language Recognition
#
# @author Jason Arhart
module Rattler
  
  autoload :Runtime, 'rattler/runtime'
  autoload :Grammar, 'rattler/grammar'  
  autoload :Parsers, 'rattler/parsers'
  autoload :BackEnd, 'rattler/back_end'
  autoload :Util, 'rattler/util'
  
  # Convenience methods for defining parsers
  #
  # @author Jason Arhart
  module HelperMethods
    
    # @private
    @@defaults = {
      :type => :packrat
    }
    
    # @private
    @@parser_types = {
      :recursive_descent  => :RecursiveDescentParser,
      :packrat            => :PackratParser,
      :wdm                => :WDMParser
    }
    
    # Define parse rules with the given block
    #
    # @return [Rattler::Parsers::Rules] a set of parse rules
    #
    def define_rules(&block)
      Rattler::Parsers.define(&block)
    end
    
    # Define a parser with the given block and compile it into a parser class
    # using the given options
    #
    # @return [Class] a new parser class
    def compile_parser(*args, &block)
      options = @@defaults
      grammar = nil
      for arg in args
        case arg
        when Hash then options = options.merge(arg)
        when String then grammar = arg
        end
      end
      base_class = options.fetch(:class) do
        Rattler::Runtime::const_get @@parser_types[options[:type]]
      end
      Rattler::BackEnd::Compiler.compile_parser(base_class,
        grammar || Rattler::Parsers.define(&block))
    end
    
    # Define a parser with the given block and compile it into match methods in
    # the given module
    def compile(mod, grammar=nil, &block)
      grammar_or_rules = grammar || Rattler::Parsers.define(&block)
      Rattler::BackEnd::Compiler.compile(mod, grammar_or_rules)
    end
    
  end
  
  include HelperMethods
  
  class <<self
    include HelperMethods
  end
  
end
