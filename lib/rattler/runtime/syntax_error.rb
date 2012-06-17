require 'rattler/runtime'

module Rattler::Runtime
  # +SyntaxError+ is raised by {Parser#raise_error} to indicate a failed parse.
  class SyntaxError < RuntimeError
  end
end
