require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator
  # @private
  module List1Generating #:nodoc:
    include PredicatePropogating

    def gen_skip(list, scope = ParserScope.empty)
      expr :block do
        (@g << "#{result_name} = false").newline
        gen_skipping(list, scope) { (@g << "#{result_name} = true").newline }
        @g << "@scanner.pos = #{end_pos_name} unless #{end_pos_name}.nil?"
        @g.newline << result_name
      end
    end

    protected

    def start_capturing(list)
      (@g << "#{accumulator_name} = []").newline
      (@g << "#{end_pos_name} = nil").newline
    end

    def gen_result(list, captures)
      @g << "@scanner.pos = #{end_pos_name} unless #{end_pos_name}.nil?"
      @g.newline << captures << " unless #{accumulator_name}.empty?"
    end

  end
end
