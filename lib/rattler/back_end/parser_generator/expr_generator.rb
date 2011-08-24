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

    def gen_dispatch_action(parser, code, scope = ParserScope.empty)
      expr :block do
        gen_capture { block_given? ? yield : gen_basic(parser, scope) }
        (@g << ' &&').newline << code.bind(scope, dispatch_action_args)
      end
    end

    def gen_direct_action(parser, code, scope = ParserScope.empty)
      expr :block do
        gen_capture { block_given? ? yield : gen_basic(parser, scope) }
        (@g << ' &&').newline <<
          '(' << code.bind(scope.capture(*direct_action_args)) << ')'
      end
    end

    def gen_token(parser, scope = ParserScope.empty)
      expr :block do
        (@g << "#{token_pos_name} = @scanner.pos").newline
        gen_intermediate_skip parser, scope
        (@g << ' &&').newline
        @g << "@scanner.string[#{token_pos_name}...(@scanner.pos)]"
      end
    end

    def gen_intermediate(parser, scope = ParserScope.empty)
      gen_basic parser, scope
    end

    def gen_intermediate_assert(parser, scope = ParserScope.empty)
      gen_assert parser, scope
    end

    def gen_intermediate_disallow(parser, scope = ParserScope.empty)
      gen_disallow parser, scope
    end

    def gen_intermediate_skip(parser, scope = ParserScope.empty)
      gen_skip parser, scope
    end

    protected

    attr_reader :choice_level, :sequence_level, :repeat_level

    def result_name
      'r'
    end

    def saved_pos_name
      "p#{sequence_level}"
    end

    def token_pos_name
      "tp#{sequence_level}"
    end

    def lookahead
      (@g << "#{saved_pos_name} = @scanner.pos").newline
      yield
      (@g << "@scanner.pos = #{saved_pos_name}").newline
    end

    def gen_capture
      @g.surround("(#{result_name} = ", ')') { yield }
    end

    def dispatch_action_args
      "[#{result_name}]"
    end

    def direct_action_args
      [result_name]
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
