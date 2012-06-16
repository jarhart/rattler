require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator

  # @private
  class GroupMatchGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating

    def gen_basic(group_match, scope = ParserScope.empty)
      expr(:block) { gen_capture group_match, result_expr(group_match) }
    end

    private

    def gen_capture(group_match, expr)
      generate group_match.match, :intermediate_skip
      (@g << ' &&').newline << expr
    end

    def result_expr(group_match)
      if group_match.capture_count == 1
        group_exprs(group_match).first
      else
        "[#{group_exprs(group_match).join ', '}]"
      end
    end

    def group_exprs(group_match)
      (1..(group_match.num_groups)).map {|n| "@scanner[#{n}]" }
    end

  end

  # @private
  class NestedGroupMatchGenerator < GroupMatchGenerator #:nodoc:
    include Nested
    include NestedSubGenerating
  end

  def GroupMatchGenerator.nested(*args)
    NestedGroupMatchGenerator.new(*args)
  end

  # @private
  class TopLevelGroupMatchGenerator < GroupMatchGenerator #:nodoc:
    include TopLevel
    include NestedSubGenerating
  end

  def GroupMatchGenerator.top_level(*args)
    TopLevelGroupMatchGenerator.new(*args)
  end

end
