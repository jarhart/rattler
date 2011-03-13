require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module RepeatGenerating #:nodoc:

    def gen_basic_nested(repeat, scope={})
      atomic_block { gen_basic_top_level repeat, scope }
    end

    def gen_basic_top_level(repeat, scope={})
      if repeat.capturing?
        gen_loop repeat, :basic_nested, scope
        gen_result accumulator_name
      else
        gen_skip_top_level repeat, scope
      end
    end

    def gen_dispatch_action_nested(repeat, code, scope={})
      atomic_block do
        gen_dispatch_action_top_level repeat, code, scope
      end
    end

    def gen_dispatch_action_top_level(repeat, code, scope={})
      gen_loop repeat, :basic, scope
      gen_result code.bind(scope, "select_captures(#{accumulator_name})")
    end

    def gen_direct_action_nested(repeat, code, scope={})
      atomic_block { gen_direct_action_top_level repeat, code, scope }
    end

    def gen_direct_action_top_level(repeat, code, scope={})
      gen_loop repeat, :basic, scope
      gen_result('(' + code.bind(scope, ["select_captures(#{accumulator_name})"]) + ')')
    end

    def gen_token_nested(repeat, scope={})
      atomic_block { gen_token_top_level repeat, scope }
    end

    def gen_token_top_level(repeat, scope={})
      gen_loop repeat, :token, scope
      gen_result "#{accumulator_name}.join"
    end

    def gen_skip_nested(repeat, scope={})
      atomic_block { gen_skip_top_level repeat, scope }
    end

    private

    def gen_loop(repeat, child_as = :basic, scope={})
      (@g << "#{accumulator_name} = []").newline
      @g << "while #{result_name} = "
      generate repeat.child, child_as, scope
      @g.block('') { @g << "#{accumulator_name} << #{result_name}" }.newline
    end

    def accumulator_name
      "a#{repeat_level}"
    end

  end
end
