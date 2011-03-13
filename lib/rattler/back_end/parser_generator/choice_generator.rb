require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class ChoiceGenerator < ExprGenerator #:nodoc:
    include NestedSubGenerating

    def gen_basic_nested(choice, scope={})
      atomic_block { gen_basic_top_level choice, scope }
    end

    def gen_basic_top_level(choice, scope={})
      @g.intersperse_nl(choice, ' ||') {|_| generate _, :basic, scope }
    end

    def gen_assert_nested(choice, scope={})
      atomic_expr { gen_assert_top_level choice, scope }
    end

    def gen_assert_top_level(choice, scope={})
      gen_intermediate_assert choice, scope
      @g << ' && true'
    end

    def gen_disallow(choice, scope={})
      @g << '!'
      gen_intermediate_assert choice, scope
    end

    def gen_dispatch_action_nested(choice, code, scope={})
      atomic_block { gen_dispatch_action_top_level choice, code, scope }
    end

    def gen_dispatch_action_top_level(choice, code, scope={})
      gen_action_code(choice) { code.bind scope, "[#{result_name}]" }
    end

    def gen_direct_action_nested(choice, code, scope={})
      atomic_block { gen_direct_action_top_level choice, code }
    end

    def gen_direct_action_top_level(choice, code, scope={})
      gen_action_code(choice) { "(#{code.bind scope, [result_name]})" }
    end

    def gen_token_nested(choice, scope={})
      atomic_block { gen_token_top_level choice, scope }
    end

    def gen_token_top_level(choice, scope={})
      @g.intersperse_nl(choice, ' ||') {|_| generate _, :token, scope }
    end

    def gen_skip_nested(choice, scope={})
      @g.surround('(', ')') { gen_skip_top_level choice, scope }
    end

    def gen_skip_top_level(choice, scope={})
      gen_intermediate_skip choice, scope
      @g << ' && true'
    end

    def gen_intermediate_assert(choice, scope={})
      atomic_block do
        @g.intersperse_nl(choice, ' ||') do |_|
          generate _, :intermediate_assert, scope
        end
      end
    end

    def gen_intermediate_skip(choice, scope={})
      atomic_block do
        @g.intersperse_nl(choice, ' ||') do |_|
          generate _, :intermediate_skip, scope
        end
      end
    end

    private

    def gen_action_code(choice, scope={})
      @g.block("(#{result_name} = begin", 'end)') do
        @g.intersperse_nl(choice, ' ||') {|child| generate child }
      end << ' && '
      @g << yield
    end

    def labeled_name
      "l#{choice_level}"
    end

  end

  # @private
  class NestedChoiceGenerator < ChoiceGenerator #:nodoc:
    include Nested
  end

  def ChoiceGenerator.nested(*args)
    NestedChoiceGenerator.new(*args)
  end

  # @private
  class TopLevelChoiceGenerator < ChoiceGenerator #:nodoc:
    include TopLevel
  end

  def ChoiceGenerator.top_level(*args)
    TopLevelChoiceGenerator.new(*args)
  end

end
