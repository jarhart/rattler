require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator
  # @private
  module List0Generating #:nodoc:

    def gen_assert(optional, scope = ParserScope.empty)
      @g << 'true'
    end

    def gen_disallow(optional, scope = ParserScope.empty)
      @g << 'false'
    end

    def gen_skip(list, scope = ParserScope.empty)
      expr :block do
        gen_skipping list, scope
        @g << "@scanner.pos = #{end_pos_name} unless #{end_pos_name}.nil?"
        @g.newline << 'true'
      end
    end

    protected

    def start_capturing(list)
      (@g << "#{accumulator_name} = []").newline
      (@g << "#{end_pos_name} = nil").newline
    end

    def gen_result(list, captures)
      @g << "@scanner.pos = #{end_pos_name} unless #{end_pos_name}.nil?"
      @g.newline << captures
    end

  end
end
