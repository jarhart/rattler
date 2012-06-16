require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator
  # @private
  module OneOrMoreGenerating #:nodoc:
    include PredicatePropogating

    def gen_skip(one_or_more, scope = ParserScope.empty)
      expr :block do
        (@g << "#{result_name} = false").newline
        @g << 'while '
        generate one_or_more.child, :intermediate_skip, scope
        @g.block('') { @g << "#{result_name} = true" }.newline
        @g << result_name
      end
    end

    protected

    def gen_result(one_or_more, captures)
      @g << captures << " unless #{accumulator_name}.empty?"
    end

  end
end
