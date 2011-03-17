require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module ListGenerating #:nodoc:

    def gen_basic(list, scope={})
      if list.capturing?
        expr(:block) { gen_capturing list, scope }
      else
        gen_skip list, scope
      end
    end

    def gen_dispatch_action(list, code, scope={})
      expr :block do
        gen_capturing list, scope do |a|
          code.bind scope, "select_captures(#{a})"
        end
      end
    end

    def gen_direct_action(list, code, scope={})
      expr :block do
        gen_capturing list, scope do |a|
          '(' + code.bind(scope, ["select_captures(#{a})"]) + ')'
        end
      end
    end

    protected

    def gen_capturing(list, scope={})
      (@g << "#{accumulator_name} = []").newline
      (@g << "#{saved_pos_name} = nil").newline
      @g << "while #{result_name} = "
      generate list.child, :basic, scope
      @g.block '' do
        (@g << "#{saved_pos_name} = @scanner.pos").newline
        (@g << "#{accumulator_name} << #{result_name}").newline
        @g << 'break unless '
        generate list.sep_parser, :intermediate_skip, scope
      end.newline
      @g << "@scanner.pos = #{saved_pos_name} unless #{saved_pos_name}.nil?"
      @g.newline
      gen_result(block_given? ? yield(accumulator_name) : accumulator_name)
    end

    def gen_skipping(list, scope={})
      (@g << "#{saved_pos_name} = nil").newline
      @g << 'while '
      generate list.child, :intermediate_skip, scope
      @g.block '' do
        yield if block_given?
        (@g << "#{saved_pos_name} = @scanner.pos").newline
        @g << 'break unless '
        generate list.sep_parser, :intermediate_skip, scope
      end.newline
      @g << "@scanner.pos = #{saved_pos_name} unless #{saved_pos_name}.nil?"
    end

    def accumulator_name
      "a#{repeat_level}"
    end

    def saved_pos_name
      "lp#{repeat_level}"
    end

  end
end
