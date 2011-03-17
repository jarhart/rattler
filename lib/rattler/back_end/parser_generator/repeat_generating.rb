require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module RepeatGenerating #:nodoc:

    def gen_basic(repeat, scope={})
      if repeat.capturing?
        expr :block do
          gen_loop(repeat) { |child| gen_nested child, :basic, scope }
          gen_result accumulator_name
        end
      else
        gen_skip repeat, scope
      end
    end

    def gen_dispatch_action(repeat, code, scope={})
      expr :block do
        gen_loop repeat
        gen_result code.bind(scope, "select_captures(#{accumulator_name})")
      end
    end

    def gen_direct_action(repeat, code, scope={})
      expr :block do
        gen_loop repeat
        gen_result('(' + code.bind(scope, ["select_captures(#{accumulator_name})"]) + ')')
      end
    end

    def gen_token(repeat, scope={})
      expr :block do
        gen_loop(repeat) { |child| generate child, :token, scope }
        gen_result "#{accumulator_name}.join"
      end
    end

    private

    def gen_loop(repeat, scope={})
      (@g << "#{accumulator_name} = []").newline
      @g << "while #{result_name} = "
      if block_given?
        yield repeat.child
      else
        generate repeat.child, :basic, scope
      end
      @g.block('') { @g << "#{accumulator_name} << #{result_name}" }.newline
    end

    def accumulator_name
      "a#{repeat_level}"
    end

  end
end
