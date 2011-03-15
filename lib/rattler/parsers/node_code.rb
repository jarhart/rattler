#
# = rattler/parsers/node_code.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  # @private
  class NodeCode #:nodoc:

    def self.bindable_code(action)
      self.new(action.target, action.method_name)
    end

    def initialize(target_name, method_name, target_attrs = {})
      @target_name = target_name
      @method_name = method_name
      @target_attrs = target_attrs
    end

    attr_reader :target_name, :method_name, :target_attrs

    def bind(scope, bind_args)
      args = [array_expr(bind_args)]
      if not scope.empty?
        labeled = '{' + scope.map {|k, v| ":#{k} => #{v}"}.join(', ') + '}'
        args << ":labeled => #{labeled}"
      end
      target_attrs.each {|k, v| args << ":#{k} => #{v.inspect}" }
      t = target_name == 'self' ? '' : "#{target_name}."
      "#{t}#{method_name}(#{args.join ', '})"
    end

    def array_expr(bind_args)
      if bind_args.respond_to? :to_str
        bind_args
      else
        '[' + bind_args.join(', ') + ']'
      end
    end

  end
end
