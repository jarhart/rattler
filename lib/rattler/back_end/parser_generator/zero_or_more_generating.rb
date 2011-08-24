require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module ZeroOrMoreGenerating #:nodoc:

    def gen_assert(zero_or_more, scope = ParserScope.empty)
      @g << 'true'
    end

    def gen_disallow(zero_or_more, scope = ParserScope.empty)
      @g << 'false'
    end

    def gen_skip(zero_or_more, scope = ParserScope.empty)
      expr :block do
        @g << 'while '
        generate zero_or_more.child, :intermediate_skip, scope
        (@g << '; end').newline
        @g << 'true'
      end
    end

    protected

    def gen_result(zero_or_more, captures)
      @g << captures
    end

  end
end
