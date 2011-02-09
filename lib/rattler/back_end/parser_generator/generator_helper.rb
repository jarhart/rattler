require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module GeneratorHelper #:nodoc:
    
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
    
    def direct_action_result(action, options = {})
      args = options[:bind_args] || [result_name]
      labeled = options[:labeled] || {}
      "(#{action.bind args, labeled})"
    end
    
    def lookahead
      (@g << "#{saved_pos_name} = @scanner.pos").newline
      yield
      (@g << "@scanner.pos = #{saved_pos_name}").newline
    end
    
    def new_level(old_level)
      old_level ? (old_level + 1) : 0
    end
    
  end
end
