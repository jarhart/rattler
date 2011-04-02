require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class DelegatingGenerator < ExprGenerator #:nodoc:

    def initialize(*args)
      @init_args = args
      super
    end

    GEN_METHOD_NAMES.each do |symbol|
      define_method(symbol) do |parser, *args|
        impl(parser, @init_args).send symbol, parser, *args
      end
    end

  end
end
