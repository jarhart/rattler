require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class RepeatGenerator < ExprGenerator #:nodoc:
    include NestedSubGenerating

    def gen_basic(repeat, scope={})
      if repeat.capturing?
        gen_capturing repeat, scope
      else
        gen_skip repeat, scope
      end
    end

    def gen_assert(repeat, scope={})
      case repeat.lower_bound
      when 0 then gen_assert_zero_or_more
      when 1 then gen_assert_one_or_more repeat.child, scope
      else gen_predicate(repeat, scope) { gen_assert_result repeat }
      end
    end

    def gen_disallow(repeat, scope={})
      case repeat.lower_bound
      when 0 then gen_disallow_zero_or_more
      when 1 then gen_disallow_one_or_more repeat.child, scope
      else gen_predicate(repeat, scope) { gen_disallow_result repeat }
      end
    end

    def gen_dispatch_action(repeat, code, scope={})
      expr :block do
        gen_loop repeat
        gen_result repeat, code.bind(scope, "select_captures(#{accumulator_name})")
      end
    end

    def gen_direct_action(repeat, code, scope={})
      expr :block do
        gen_loop repeat
        gen_result(repeat, '(' + code.bind(scope, ["select_captures(#{accumulator_name})"]) + ')')
      end
    end

    def gen_token(repeat, scope={})
      expr :block do
        gen_loop(repeat) { |child| generate child, :token, scope }
        gen_result repeat, "#{accumulator_name}.join"
      end
    end

    def gen_skip(repeat, scope={})
      case repeat.lower_bound
      when 0 then gen_skip_zero_or_more repeat.child, scope
      when 1 then gen_skip_one_or_more repeat.child, scope
      else gen_skip_default repeat, scope
      end
    end

    protected

    def gen_capturing(repeat, scope)
      expr :block do
        gen_loop(repeat) { |child| gen_nested child, :basic, scope }
        gen_result repeat, accumulator_name
      end
    end

    def gen_loop(repeat, scope={})
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
      if repeat.lower_bound > 1
        (@g << "#{saved_pos_name} = @scanner.pos").newline
      end
    end

    def gen_loop_body(repeat)
      @g << "#{accumulator_name} << #{result_name}"
      if repeat.upper_bound?
        @g.newline << "break if #{accumulator_name}.size >= #{repeat.upper_bound}"
      end
    end

    def gen_result(repeat, captures)
      case repeat.lower_bound
      when 0 then @g << captures
      when 1 then @g << captures << " unless #{accumulator_name}.empty?"
      else
        @g.block "if #{accumulator_name}.size >= #{repeat.lower_bound}", '' do
          @g << captures
        end
        @g.block 'else' do
          (@g << "@scanner.pos = #{saved_pos_name}").newline << 'false'
        end
      end
    end

    def gen_assert_zero_or_more
      @g << 'true'
    end

    def gen_disallow_zero_or_more
      @g << 'false'
    end

    def gen_assert_one_or_more(child, scope)
      gen_top_level child, :assert, scope
    end

    def gen_disallow_one_or_more(child, scope)
      gen_top_level child, :disallow, scope
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

    def gen_skip_zero_or_more(child, scope)
      expr :block do
        @g << 'while '
        generate child, :intermediate_skip, scope
        (@g << '; end').newline
        @g << 'true'
      end
    end

    def gen_skip_one_or_more(child, scope={})
      expr :block do
        (@g << "#{result_name} = false").newline
        @g << 'while '
        generate child, :intermediate_skip, scope
        @g.block('') { @g << "#{result_name} = true" }.newline
        @g << result_name
      end
    end

    def gen_skip_default(repeat, scope={})
      expr :block do
        setup_skip_loop repeat
        @g << 'while '
        generate repeat.child, :intermediate_skip, scope
        @g.block('') { gen_skip_loop_body repeat }.newline
        gen_skip_result repeat
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
  class NestedRepeatGenerator < RepeatGenerator #:nodoc:
    include Nested
  end

  def RepeatGenerator.nested(*args)
    NestedRepeatGenerator.new(*args)
  end

  # @private
  class TopLevelRepeatGenerator < RepeatGenerator #:nodoc:
    include TopLevel
  end

  def RepeatGenerator.top_level(*args)
    TopLevelRepeatGenerator.new(*args)
  end

end
