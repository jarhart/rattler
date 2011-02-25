require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module RepeatGenerating #:nodoc:

    def gen_basic_nested(repeat)
      atomic_block { gen_basic_top_level repeat }
    end

    def gen_basic_top_level(repeat)
      if repeat.capturing?
        gen_loop repeat, :basic_nested
        gen_result accumulator_name
      else
        gen_skip_top_level repeat
      end
    end

    def gen_dispatch_action_nested(repeat, code)
      atomic_block do
        gen_dispatch_action_top_level repeat, code
      end
    end

    def gen_dispatch_action_top_level(repeat, code)
      gen_loop repeat
      gen_result dispatch_action_result(code,
          :array_expr => "select_captures(#{accumulator_name})")
    end

    def gen_direct_action_nested(repeat, action)
      atomic_block { gen_direct_action_top_level repeat, action }
    end

    def gen_direct_action_top_level(repeat, action)
      gen_loop repeat
      gen_result direct_action_result(action,
          :bind_args => ["select_captures(#{accumulator_name})"])
    end

    def gen_token_nested(repeat)
      atomic_block { gen_token_top_level repeat }
    end

    def gen_token_top_level(repeat)
      gen_loop repeat, :token
      gen_result "#{accumulator_name}.join"
    end

    def gen_skip_nested(repeat)
      atomic_block { gen_skip_top_level repeat }
    end

    private

    def gen_loop(repeat, child_as = :basic)
      (@g << "#{accumulator_name} = []").newline
      @g << "while #{result_name} = "
      generate repeat.child, child_as
      @g.block('') { @g << "#{accumulator_name} << #{result_name}" }.newline
    end

    def accumulator_name
      "a#{repeat_level}"
    end

  end
end
