require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class GeneralRepeatGenerator < ExprGenerator #:nodoc:
    include NestedSubGenerating

    def gen_basic(repeat, scope = ParserScope.empty)
      if repeat.capturing?
        gen_capturing repeat, scope
      else
        gen_skip repeat, scope
      end
    end

    def gen_assert(repeat, scope = ParserScope.empty)
      gen_predicate(repeat, scope) { gen_assert_result repeat }
    end

    def gen_disallow(repeat, scope = ParserScope.empty)
      gen_predicate(repeat, scope) { gen_disallow_result repeat }
    end

    def gen_dispatch_action(repeat, code, scope = ParserScope.empty)
      expr :block do
        gen_loop repeat, scope
        gen_result repeat, code.bind(scope, "select_captures(#{accumulator_name})")
      end
    end

    def gen_direct_action(repeat, code, scope = ParserScope.empty)
      expr :block do
        gen_loop repeat, scope
        gen_result(repeat, '(' + code.bind(scope.capture("select_captures(#{accumulator_name})")) + ')')
      end
    end

    def gen_token(repeat, scope = ParserScope.empty)
      expr :block do
        gen_loop(repeat, scope) { |child| generate child, :token, scope }
        gen_result repeat, "#{accumulator_name}.join"
      end
    end

    def gen_skip(repeat, scope = ParserScope.empty)
      expr :block do
        setup_skip_loop repeat
        @g << 'while '
        generate repeat.child, :intermediate_skip, scope
        @g.block('') { gen_skip_loop_body repeat }.newline
        gen_skip_result repeat
      end
    end

    protected

    def gen_capturing(repeat, scope)
      expr :block do
        gen_loop(repeat, scope) { |child| gen_nested child, :basic, scope }
        gen_result repeat, accumulator_name
      end
    end

    def gen_loop(repeat, scope)
      setup_loop repeat
      @g << "while #{result_name} = "
      if block_given?
        yield repeat.child
      else
        generate repeat.child, :basic, scope
      end
      @g.block('') { gen_loop_body repeat }.newline
    end

    def setup_loop(repeat)
      (@g << "#{accumulator_name} = []").newline
      if repeat.respond_to? :lower_bound and repeat.lower_bound > 1
        (@g << "#{saved_pos_name} = @scanner.pos").newline
      end
    end

    def gen_loop_body(repeat)
      @g << "#{accumulator_name} << #{result_name}"
      if repeat.respond_to? :upper_bound and repeat.upper_bound?
        @g.newline << "break if #{accumulator_name}.size >= #{repeat.upper_bound}"
      end
    end

    def gen_result(repeat, captures)
      @g.block "if #{accumulator_name}.size >= #{repeat.lower_bound}", '' do
        @g << captures
      end
      @g.block 'else' do
        (@g << "@scanner.pos = #{saved_pos_name}").newline << 'false'
      end
    end

    def gen_predicate(repeat, scope)
      expr :block do
        setup_skip_loop repeat
        @g << 'while '
        generate repeat.child, :intermediate_skip, scope
        @g.block('') { gen_assert_loop_body repeat }.newline
        yield
      end
    end

    def setup_skip_loop(repeat)
      (@g << "#{count_name} = 0").newline
      (@g << "#{saved_pos_name} = @scanner.pos").newline
    end

    def gen_skip_loop_body(repeat)
      @g << "#{count_name} += 1"
      if repeat.upper_bound?
        @g.newline << "break if #{count_name} >= #{repeat.upper_bound}"
      end
    end

    def gen_skip_result(repeat)
      @g.block "if #{count_name} >= #{repeat.lower_bound}", '' do
        @g << 'true'
      end
      @g.block 'else' do
        (@g << "@scanner.pos = #{saved_pos_name}").newline << 'false'
      end
    end

    def gen_assert_loop_body(repeat)
      @g << "#{count_name} += 1"
      @g.newline << "break if #{count_name} >= #{repeat.lower_bound}"
    end

    def gen_assert_result(repeat)
      @g << "@scanner.pos = #{saved_pos_name}"
      @g.newline << "(#{count_name} >= #{repeat.lower_bound})"
    end

    def gen_disallow_result(repeat)
      @g << "@scanner.pos = #{saved_pos_name}"
      @g.newline << "(#{count_name} < #{repeat.lower_bound})"
    end

    def accumulator_name
      "a#{repeat_level}"
    end

    def saved_pos_name
      "rp#{repeat_level}"
    end

    def count_name
      "c#{repeat_level}"
    end

  end

  # @private
  class NestedGeneralRepeatGenerator < GeneralRepeatGenerator #:nodoc:
    include Nested
  end

  def GeneralRepeatGenerator.nested(*args)
    NestedGeneralRepeatGenerator.new(*args)
  end

  # @private
  class TopLevelGeneralRepeatGenerator < GeneralRepeatGenerator #:nodoc:
    include TopLevel
  end

  def GeneralRepeatGenerator.top_level(*args)
    TopLevelGeneralRepeatGenerator.new(*args)
  end

end
