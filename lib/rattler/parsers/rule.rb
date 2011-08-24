#
# = rattler/parsers/rule.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +Rule+ is a binding for a parser that can be referenced by name from
  # another rule.
  #
  # @author Jason Arhart
  #
  class Rule < Rattler::Util::Node

    # Create a new +Rule+.
    #
    # @param [Symbol, String] name the name of the new rule
    # @param [Parser] parser the parser that defines the rule body
    #
    # @return [Rule] a new parse rule
    def self.[](name, parser, attrs={})
      self.new(parser, attrs.merge(:name => name.to_sym))
    end

    alias_method :expr, :child

    # Parse using +scanner+ and +rules+ and on success return the result, on
    # failure return a false value.
    #
    # @param scanner (see Parser#parse_labeled)
    # @param rules (see Parser#parse_labeled)
    #
    # @return (see Parser#parse_labeled)
    def parse(scanner, rules, scope = ParserScope.empty)
      catch(:rule_failed) do
        return expr.parse(scanner, rules, scope)
      end
      false
    end

    def with_expr(new_expr)
      Rule[name, new_expr, attrs]
    end

    # @param (see Parser#with_ws)
    # @return (see Parser#with_ws)
    def with_ws(ws)
      self.with_expr expr.with_ws(ws)
    end

  end
end
