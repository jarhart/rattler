require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class GroupMatchGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating

    def gen_basic_nested(group_match)
      atomic_block { gen_basic_top_level group_match }
    end

    def gen_basic_top_level(group_match)
      gen_capture group_match, result_expr(group_match)
    end

    def gen_dispatch_action_nested(group_match, code)
      atomic_block { gen_dispatch_action_top_level group_match, code }
    end

    def gen_dispatch_action_top_level(group_match, code)
      gen_capture group_match, dispatch_action_result(code,
                      :array_expr => "[#{group_exprs(group_match).join ', '}]")
    end

    def gen_direct_action_nested(group_match, code)
      atomic_block { gen_direct_action_top_level group_match, code }
    end

    def gen_direct_action_top_level(group_match, code)
      gen_capture group_match, direct_action_result(code,
                                        :bind_args => group_exprs(group_match))
    end

    private

    def gen_capture(group_match, expr)
      generate group_match.match, :intermediate_skip
      (@g << ' &&').newline << expr
    end

    def result_expr(group_match)
      if group_match.num_groups == 1
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
