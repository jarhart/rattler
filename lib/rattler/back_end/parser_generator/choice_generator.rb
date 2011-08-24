require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class ChoiceGenerator < ExprGenerator #:nodoc:
    include NestedSubGenerating

    def gen_basic(choice, scope = ParserScope.empty)
      expr :block do
        @g.intersperse_nl(choice, ' ||') {|_| generate _, :basic, scope }
      end
    end

    def gen_assert(choice, scope = ParserScope.empty)
      expr do
        gen_intermediate_assert choice, scope
        @g << ' && true'
      end
    end

    def gen_disallow(choice, scope = ParserScope.empty)
      @g << '!'
      gen_intermediate_assert choice, scope
    end

    def gen_dispatch_action(choice, code, scope = ParserScope.empty)
      expr :block do
        gen_action_code(choice) { code.bind scope, "[#{result_name}]" }
      end
    end

    def gen_direct_action(choice, code, scope = ParserScope.empty)
      expr :block do
        action = code.bind(scope.capture(result_name))
        gen_action_code(choice) { "(#{action})" }
      end
    end

    def gen_token(choice, scope = ParserScope.empty)
      expr :block do
        @g.intersperse_nl(choice, ' ||') {|_| generate _, :token, scope }
      end
    end

    def gen_skip(choice, scope = ParserScope.empty)
      expr do
        gen_intermediate_skip choice, scope
        @g << ' && true'
      end
    end

    def gen_intermediate_assert(choice, scope = ParserScope.empty)
      @g.block 'begin' do
        @g.intersperse_nl(choice, ' ||') do |_|
          generate _, :intermediate_assert, scope
        end
      end
    end

    def gen_intermediate_skip(choice, scope = ParserScope.empty)
      @g.block 'begin' do
        @g.intersperse_nl(choice, ' ||') do |_|
          generate _, :intermediate_skip, scope
        end
      end
    end

    private

    def gen_action_code(choice, scope = ParserScope.empty)
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
