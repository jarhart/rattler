#
# = rattler/runtime/syntax_error.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/runtime'

module Rattler::Runtime
  # +SyntaxError+ is raised by {Parser#raise_error} to indicate a failed parse.
  #
  # @author Jason Arhart
  #
  class SyntaxError < RuntimeError
  end
end
