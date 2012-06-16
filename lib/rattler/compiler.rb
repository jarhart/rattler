require 'rattler'

module Rattler

  # The +Compiler+ module contains the classes and methods used to turn
  # parser models into ruby code.
  module Compiler
    autoload :Compiler, 'rattler/compiler/compiler'
    autoload :ParserGenerator, 'rattler/compiler/parser_generator'
    autoload :RubyGenerator, 'rattler/compiler/ruby_generator'
    autoload :Optimizer, 'rattler/compiler/optimizer'
  end
end
