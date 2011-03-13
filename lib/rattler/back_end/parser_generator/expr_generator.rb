require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class ExprGenerator #:nodoc:

    include Rattler::Parsers

    def initialize(g, choice_level=nil, sequence_level=nil, repeat_level=nil)
      @g = g
      @choice_level = choice_level
      @sequence_level = sequence_level
      @repeat_level = repeat_level
    end

    def gen_basic_nested(parser, scope={})
      gen_basic parser, scope
    end

    def gen_basic_top_level(parser, scope={})
      gen_basic parser, scope
    end

    def gen_assert_nested(parser, scope={})
      gen_assert parser, scope
    end

    def gen_assert_top_level(parser, scope={})
      gen_assert parser, scope
    end

    def gen_disallow_nested(parser, scope={})
      gen_disallow parser, scope
    end

    def gen_disallow_top_level(parser, scope={})
      gen_disallow parser, scope
    end

    def gen_dispatch_action_nested(parser, code, scope={})
      gen_dispatch_action parser, code, scope
    end

    def gen_dispatch_action_top_level(parser, code, scope={})
      gen_dispatch_action parser, code, scope
    end

    def gen_direct_action_nested(parser, code, scope={})
      gen_direct_action parser, code, scope
    end

    def gen_direct_action_top_level(parser, code, scope={})
      gen_direct_action parser, code, scope
    end

    def gen_token_nested(parser, scope={})
      atomic_block { gen_token_top_level parser, scope }
    end

    def gen_token_top_level(parser, scope={})
      (@g << "tp = @scanner.pos").newline
      gen_intermediate_skip parser, scope
      (@g << ' &&').newline
      @g << "@scanner.string[tp...(@scanner.pos)]"
    end

    def gen_skip_nested(parser, scope={})
      gen_skip parser, scope
    end

    def gen_skip_top_level(parser, scope={})
      gen_skip parser, scope
    end

    def gen_intermediate(parser, scope={})
      gen_basic_nested parser, scope
    end

    def gen_intermediate_assert(parser, scope={})
      gen_assert_nested parser, scope
    end

    def gen_intermediate_disallow(parser, scope={})
      gen_disallow_nested parser, scope
    end

    def gen_intermediate_skip(parser, scope={})
      gen_skip_nested parser, scope
    end

    protected

    attr_reader :choice_level, :sequence_level, :repeat_level

    def atomic_expr
      @g.surround('(', ')') { yield }
    end

    def atomic_block
      @g.block('begin') { yield }
    end

    def result_name
      'r'
    end

    def saved_pos_name
      "p#{sequence_level}"
    end

    def lookahead
      (@g << "#{saved_pos_name} = @scanner.pos").newline
      yield
      (@g << "@scanner.pos = #{saved_pos_name}").newline
    end

  end

  # @private
  class TopLevelGenerator < ExprGenerator #:nodoc:
    include TopLevelSubGenerating

    def generate(parser)
      super
    end
  end

end
