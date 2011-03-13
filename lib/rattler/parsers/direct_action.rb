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
  class DirectAction < Parser
    include Combining

    def self.[](child, code)
      self.new(child, :code => code)
    end

    # @private
    def self.parsed(results, *_) #:nodoc:
      self[*results]
    end

    # If the wrapped parser matches at the parse position, return the result
    # of applying the symantic action, otherwise return a false value.
    #
    # @param (see Parser#parse_labeled)
    #
    # @return the result of applying the symantic action, or a false value if
    #   the parse failed.
    def parse(scanner, rules, scope = {})
      if result = parse_child(child, scanner, rules, scope) {|_| scope = _ }
        if not capturing?
          apply([])
        elsif result.respond_to?(:to_ary)
          apply(result, scope)
        else
          apply([result], scope)
        end
      end
    end

    def bindable_code
      @bindable_code ||= ActionCode.new(code)
    end

    def bind(scope, bind_args)
      bindable_code.bind(scope, bind_args)
    end

    private

    def parse_child(child, scanner, rules, scope)
      if child.is_a? Sequence
        child.parse_and_yield_scope(scanner, rules, scope) {|_| yield _ }
      else
        child.parse(scanner, rules, scope) {|_| yield _ }
      end
    end

    def apply(results, scope={})
      code_scope = {}
      scope.each {|k, v| code_scope[k] = v.inspect }
      if child.variable_capture_count?
        eval(bind(code_scope, [results.inspect]))
      else
        eval(bind(code_scope, results.map {|_| _.inspect }))
      end
    end

  end
end
