require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class DispatchActionCode #:nodoc:

    def self.bindable_code(action)
      self.new(action.target, action.method_name)
    end

    def initialize(target_name, method_name)
      @target_name = target_name
      @method_name = method_name
    end

    attr_reader :target_name, :method_name

    def bind(array_expr, labeled)
      args = [array_expr]
      if labeled and not labeled.empty?
        if labeled.respond_to?(:to_hash)
          labeled = '{' + labeled.map {|k, v| ":#{k} => #{v}"}.join(', ') + '}'
        end
        args << ":labeled => #{labeled}"
      end
      t = target_name == 'self' ? '' : "#{target_name}."
      "#{t}#{method_name}(#{args.join ', '})"
    end

  end

end
