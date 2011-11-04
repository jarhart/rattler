#
# = rattler/back_end.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler'

module Rattler
  #
  # The +BackEnd+ module contains the classes used to turn abstract parser
  # models into concrete ruby code.
  #
  # @author Jason Arhart
  #
  module BackEnd
    autoload :Compiler, 'rattler/back_end/compiler'
    autoload :ParserGenerator, 'rattler/back_end/parser_generator'
    autoload :RubyGenerator, 'rattler/back_end/ruby_generator'
    autoload :Optimizer, 'rattler/back_end/optimizer'
    autoload :Transformation, 'rattler/back_end/transformation'
    autoload :TransformationSequence, 'rattler/back_end/transformation_sequence'
  end
end
