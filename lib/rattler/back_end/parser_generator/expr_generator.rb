require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class ExprGenerator #:nodoc:
    # include GeneratorHelper

    include Rattler::Parsers

    def initialize(g, choice_level=nil, sequence_level=nil, repeat_level=nil)
      @g = g
      @choice_level = choice_level
      @sequence_level = sequence_level
      @repeat_level = repeat_level
    end

    def gen_basic_nested(parser)
      gen_basic parser
    end

    def gen_basic_top_level(parser)
      gen_basic parser
    end

    def gen_assert_nested(parser)
      gen_assert parser
    end

    def gen_assert_top_level(parser)
      gen_assert parser
    end

    def gen_disallow_nested(parser)
      gen_disallow parser
    end

    def gen_disallow_top_level(parser)
      gen_disallow parser
    end

    def gen_dispatch_action_nested(parser, target, method_name)
      gen_dispatch_action parser, target, method_name
    end

    def gen_dispatch_action_top_level(parser, target, method_name)
      gen_dispatch_action parser, target, method_name
    end

    def gen_direct_action_nested(parser, action)
      gen_direct_action parser, action
    end

    def gen_direct_action_top_level(parser, action)
      gen_direct_action parser, action
    end

    def gen_token_nested(parser)
      atomic_block { gen_token_top_level parser }
    end

    def gen_token_top_level(parser)
      (@g << "tp = @scanner.pos").newline
      gen_intermediate_skip parser
      (@g << ' &&').newline
      @g << "@scanner.string[tp...(@scanner.pos)]"
    end

    def gen_skip_nested(parser)
      gen_skip parser
    end

    def gen_skip_top_level(parser)
      gen_skip parser
    end

    def gen_intermediate(parser)
      gen_basic_nested parser
    end

    def gen_intermediate_assert(parser)
      gen_assert_nested parser
    end

    def gen_intermediate_disallow(parser)
      gen_disallow_nested parser
    end

    def gen_intermediate_skip(parser)
      gen_skip_nested parser
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

    def dispatch_action_result(target, method_name, options = {})
      args = [options[:array_expr] || "[#{result_name}]"]
      labeled = options[:labeled]
      if labeled and not labeled.empty?
        if labeled.respond_to?(:to_hash)
          labeled = '{' + labeled.map {|k, v| ":#{k} => #{v}"}.join(', ') + '}'
        end
        args << ":labeled => #{labeled}"
      end
      t = target == 'self' ? '' : "#{target}."
      "#{t}#{method_name}(#{args.join ', '})"
    end

    def direct_action_result(code, options = {})
      args = options[:bind_args] || [result_name]
      labeled = options[:labeled] || {}
      "(#{code.bind args, labeled})"
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
