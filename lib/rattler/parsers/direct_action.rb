#
# = rattler/parsers/direct_action.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +DirectAction+ decorates a parser to peform a symantic action on success by
  # evaluating ruby code.
  #
  # @author Jason Arhart
  #
  class DirectAction < SemanticAttribute

    def self.[](child, code)
      self.new(child, :code => code.strip)
    end

    # @private
    def self.parsed(results, *_) #:nodoc:
      optional_expr, code = results
      expr = optional_expr.first || ESymbol[]
      self[expr, code]
    end

    protected

    def create_bindable_code
      ActionCode.new(code)
    end

  end
end
