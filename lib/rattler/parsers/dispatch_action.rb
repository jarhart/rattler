#
# = rattler/parsers/dispatch_action.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +DispatchAction+ decorates a parser to peform a symantic action on success
  # by dispatching to a method.
  #
  # @author Jason Arhart
  #
  class DispatchAction < Parser
    include Combining

    # @private
    @@node_defaults = {
      :target => 'Rattler::Runtime::ParseNode',
      :method => 'parsed'
    }

    # @private
    def self.parsed(results, *_) #:nodoc:
      attributed, optional_attribute = results
      self[attributed, optional_attribute.first || @@node_defaults[:target]]
    end

    # @private
    def self.parse_attrs_arg(arg) #:nodoc:
      case arg
      when Hash
        arg
      when /^\s*(.+?)\s*\.\s*(.+?)\s*$/
        { :target => $1, :method => $2 }
      else
        { :target => arg.to_s.strip }
      end
    end

    # Create a new parser that decorates a parser to peform a symantic
    # on success.
    #
    # @overload initialize(parser, opts={})
    #   @param [Parser] parser
    #   @option opts [String] target ('Rattler::Runtime::ParseNode') the
    #     object on which to invoke a method as the symantic action
    #   @option opts [String] method ('parsed') the name of the method to
    #     invoke as the symantic action
    #
    # @overload initialize(method_spec)
    #   @param [String] method_spec a specification of the target and optional
    #     method name separated by "."
    #
    def initialize(children, attrs_arg={})
      super(children, self.class.parse_attrs_arg(attrs_arg))
      @@node_defaults.each {|k, v| attrs[k] ||= v } unless attrs[:code]
      @method_name = attrs[:method]
    end

    # the name of the method used as the symantic action
    attr_reader :method_name

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
      @bindable_code ||= NodeCode.new(target, method_name)
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
      attrs = scope.empty? ? {} : {:labeled => scope}
      target_class.send method_name, results, attrs
    end

    def target_class
      @target_class ||= target.split('::').inject(Kernel, :const_get)
    end

  end
end
