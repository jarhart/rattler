require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class ZeroOrMoreGenerator < RepeatGenerator #:nodoc:
    include NestedSubGenerating

    def gen_assert(zero_or_more, scope={})
      gen_assert_zero_or_more
    end

    def gen_disallow(zero_or_more, scope={})
      gen_disallow_zero_or_more
    end

    def gen_skip(zero_or_more, scope={})
      gen_skip_zero_or_more zero_or_more.child, scope
    end

    protected

    def setup_loop(repeat)
      (@g << "#{accumulator_name} = []").newline
    end

    def gen_loop_body(repeat)
      @g << "#{accumulator_name} << #{result_name}"
    end

    def gen_result(zero_or_more, captures)
      @g << captures
    end

  end

  # @private
  class NestedZeroOrMoreGenerator < ZeroOrMoreGenerator #:nodoc:
    include Nested
  end

  def ZeroOrMoreGenerator.nested(*args)
    NestedZeroOrMoreGenerator.new(*args)
  end

  # @private
  class TopLevelZeroOrMoreGenerator < ZeroOrMoreGenerator #:nodoc:
    include TopLevel
  end

  def ZeroOrMoreGenerator.top_level(*args)
    TopLevelZeroOrMoreGenerator.new(*args)
  end

end
