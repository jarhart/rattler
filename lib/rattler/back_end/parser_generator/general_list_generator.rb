require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class GeneralListGenerator < ExprGenerator #:nodoc:
    include NestedSubGenerating

    def initialize(*args)
      @init_args = args
      super
    end

    def gen_basic(list, scope={})
      if list.capturing?
        gen_capturing list, scope
      else
        gen_skip list, scope
      end
    end

    def gen_dispatch_action(list, code, scope={})
      gen_capturing list, scope do |a|
        code.bind scope, "select_captures(#{a})"
      end
    end

    def gen_direct_action(list, code, scope={})
      gen_capturing list, scope do |a|
        '(' + code.bind(scope, ["select_captures(#{a})"]) + ')'
      end
    end

    def gen_assert(list, scope={})
      gen_predicate(list, scope) do
        @g.newline << "#{count_name} >= #{list.lower_bound}"
      end
    end

    def gen_disallow(list, scope={})
      gen_predicate(list, scope) do
        @g.newline << "#{count_name} < #{list.lower_bound}"
      end
    end

    def gen_skip(list, scope={})
      expr :block do
        (@g << "#{count_name} = 0").newline
        (@g << "#{start_pos_name} = @scanner.pos").newline
        gen_skipping(list, scope) { (@g << "#{count_name} += 1").newline }
        gen_skipping_result list
      end
    end

    protected

    def gen_capturing(list, scope)
      expr :block do
        start_capturing list
        gen_capturing_loop list, scope
        gen_result(list, block_given? ? yield(accumulator_name) : accumulator_name)
      end
    end

    def start_capturing(list)
      (@g << "#{accumulator_name} = []").newline
      (@g << "#{start_pos_name} = @scanner.pos").newline
      (@g << "#{end_pos_name} = nil").newline
    end

    def gen_capturing_loop(list, scope)
      @g << "while #{result_name} = "
      generate list.child, :basic, scope
      @g.block '' do
        @g << "#{end_pos_name} = @scanner.pos"
        gen_capturing_loop_body list
        gen_skip_separator list.sep_parser, scope
      end.newline
    end

    def gen_capturing_loop_body(list)
      @g.newline << "#{accumulator_name} << #{result_name}"
      gen_upper_bound_check list, "#{accumulator_name}.size"
    end

    def gen_result(list, captures)
      @g.block "if #{accumulator_name}.size >= #{list.lower_bound}", '' do
        @g << "@scanner.pos = #{end_pos_name} unless #{end_pos_name}.nil?"
        @g.newline << captures
      end
      @g.block 'else' do
        (@g << "@scanner.pos = #{start_pos_name}").newline << 'false'
      end
    end

    def gen_predicate(list, scope)
      expr :block do
        @g << "#{count_name} = 0"
        @g.newline << "#{start_pos_name} = @scanner.pos"
        gen_loop list, :intermediate_skip, scope do
          gen_predicate_loop_body list
        end
        @g.newline << "@scanner.pos = #{start_pos_name}"
        yield
      end
    end

    def gen_predicate_loop_body(list)
      @g << "#{count_name} += 1"
      gen_upper_bound_check list, count_name
    end

    def gen_skipping(list, scope)
      @g << "#{end_pos_name} = nil"
      gen_loop list, :intermediate_skip, scope do
        yield if block_given?
        gen_skipping_loop_body list
      end
      @g.newline
    end

    def gen_skipping_loop_body(list)
      @g << "#{end_pos_name} = @scanner.pos"
      gen_upper_bound_check list, count_name
    end

    def gen_skipping_result(list)
      @g.block "if #{count_name} >= #{list.lower_bound}", '' do
        @g << "@scanner.pos = #{end_pos_name} unless #{end_pos_name}.nil?"
        @g.newline << 'true'
      end
      @g.block 'else' do
        @g << "@scanner.pos = #{start_pos_name}"
        @g.newline << 'false'
      end
    end

    def gen_loop(list, term_as, scope)
      @g.newline << 'while '
      generate list.term_parser, term_as, scope
      @g.block '' do
        yield if block_given?
        gen_skip_separator list.sep_parser, scope
      end
    end

    def gen_upper_bound_check(list, count_expr)
      if list.upper_bound?
        @g.newline << "break unless #{count_expr} < #{list.upper_bound}"
      end
    end

    def gen_skip_separator(sep_parser, scope)
      @g.newline << 'break unless '
      generate sep_parser, :intermediate_skip, scope
    end

    def accumulator_name
      "a#{repeat_level}"
    end

    def start_pos_name
      "sp#{repeat_level}"
    end

    def end_pos_name
      "ep#{repeat_level}"
    end

    def count_name
      "c#{repeat_level}"
    end

  end

  # @private
  class NestedGeneralListGenerator < GeneralListGenerator #:nodoc:
    include Nested
  end

  def GeneralListGenerator.nested(*args)
    NestedGeneralListGenerator.new(*args)
  end

  # @private
  class TopLevelGeneralListGenerator < GeneralListGenerator #:nodoc:
    include TopLevel
  end

  def GeneralListGenerator.top_level(*args)
    TopLevelGeneralListGenerator.new(*args)
  end

end
