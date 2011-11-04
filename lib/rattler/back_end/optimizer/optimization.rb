require 'rattler'

module Rattler::BackEnd::Optimizer
  #
  # An +Optimization+ represents a simple transformation of a parser model into
  # an equivalent model that can result in more efficient parsing code.
  # Subclasses override <tt>#_applies_to?</tt> and <tt>#_apply</tt> to define
  # an optimization.
  #
  # @author Jason Arhart
  #
  Optimization = ::Rattler::BackEnd::Transformation
end
