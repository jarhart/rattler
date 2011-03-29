require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class OneOrMoreGenerator < RepeatGenerator #:nodoc:
    include NestedSubGenerating

    def gen_skip(one_or_more, scope={})
      gen_skip_one_or_more one_or_more.child, scope
    end

    protected

    def setup_loop(repeat)
      (@g << "#{accumulator_name} = []").newline
    end

    def gen_loop_body(repeat)
      @g << "#{accumulator_name} << #{result_name}"
    end

    def gen_result(one_or_more, captures)
      @g << captures << " unless #{accumulator_name}.empty?"
    end

  end

  # @private
  class NestedOneOrMoreGenerator < OneOrMoreGenerator #:nodoc:
    include Nested
    include PredicatePropogating
  end

  def OneOrMoreGenerator.nested(*args)
    NestedOneOrMoreGenerator.new(*args)
  end

  # @private
  class TopLevelOneOrMoreGenerator < OneOrMoreGenerator #:nodoc:
    include TopLevel

    def gen_assert(parser, scope = {})
      gen_assert_one_or_more parser.child, scope
    end

    def gen_disallow(parser, scope = {})
      gen_disallow_one_or_more parser.child, scope
    end

  end

  def OneOrMoreGenerator.top_level(*args)
    TopLevelOneOrMoreGenerator.new(*args)
  end

end
