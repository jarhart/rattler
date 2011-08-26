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
  class DispatchAction < SemanticAttribute

    # @private
    @@node_defaults = {
      :target => 'Rattler::Runtime::ParseNode',
      :method => 'parsed'
    }

    # @private
    def self.parsed(results, *_) #:nodoc:
      optional_expr, optional_attribute, optional_name = results
      expr = optional_expr.first || ESymbol[]
      a = self[expr, optional_attribute.first || @@node_defaults[:target]]
      unless optional_name.empty?
        a.with_attrs(:target_attrs => {:name => eval(optional_name.first, TOPLEVEL_BINDING)})
      else
        a
      end
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
      @target_attrs = attrs[:target_attrs] || {}
    end

    attr_reader :method_name, :target_attrs

    protected

    def create_bindable_code
      NodeCode.new(target, method_name, target_attrs)
    end

    private

    def apply(scope)
      attrs = scope.bindings.empty? ? {} : {:labeled => scope.bindings}
      args = if child.variable_capture_count?
        scope.captures.first
      else
        scope.captures
      end
      target_class.send method_name, args, attrs
    end

    def target_class
      @target_class ||= target.split('::').inject(Kernel, :const_get)
    end

  end
end
