require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module List0Generating #:nodoc:

    def gen_assert(optional, scope={})
      @g << 'true'
    end

    def gen_disallow(optional, scope={})
      @g << 'false'
    end

    def gen_skip(list, scope={})
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
