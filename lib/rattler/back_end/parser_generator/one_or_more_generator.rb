require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class OneOrMoreGenerator < ExprGenerator #:nodoc:
    include RepeatGenerating
    include NestedSubGenerating
    include PredicatePropogating

    def gen_skip_top_level(one_or_more, scope={})
      (@g << "#{result_name} = false").newline
      @g << 'while '
      generate one_or_more.child, :intermediate_skip, scope
      @g.block('') { @g << "#{result_name} = true" }.newline
      @g << result_name
    end

    protected

    def gen_result(captures)
      @g << captures << " unless #{accumulator_name}.empty?"
    end

  end

  # @private
  class NestedOneOrMoreGenerator < OneOrMoreGenerator #:nodoc:
    include Nested
  end

  def OneOrMoreGenerator.nested(*args)
    NestedOneOrMoreGenerator.new(*args)
  end

  # @private
  class TopLevelOneOrMoreGenerator < OneOrMoreGenerator #:nodoc:
    include TopLevel

    def gen_assert(parser, scope = {})
      generate parser.child, :assert_top_level, scope
    end

    def gen_disallow(parser, scope = {})
      generate parser.child, :disallow_top_level, scope
    end

  end

  def OneOrMoreGenerator.top_level(*args)
    TopLevelOneOrMoreGenerator.new(*args)
  end

end
