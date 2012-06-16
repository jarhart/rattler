require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator

  # @private
  class SequenceGenerator < ExprGenerator #:nodoc:
    include SequenceGenerating

    def gen_basic(sequence, scope = ParserScope.empty)
      with_backtracking do
        gen_children_capturing(sequence, scope.nest) do |last_child, scope|
          if sequence.capture_count == 1 and last_child.capturing?
            gen_nested last_child, :basic, scope
          else
            @g.suffix(' &&') { scope = gen_capturing last_child, scope }
            @g.newline << result_expr(scope)
          end
        end
      end
    end

    private

    def result_expr(scope)
      case scope.captures.size
      when 0 then 'true'
      when 1 then scope.captures[0]
      else result_array_expr(scope)
      end
    end

    def result_array_expr(scope)
      expr = '[' + scope.captures.join(', ') + ']'
      scope.captures_decidable? ? expr : "select_captures(#{expr})"
    end

  end

  # @private
  class NestedSequenceGenerator < SequenceGenerator #:nodoc:
    include Nested
  end

  def SequenceGenerator.nested(*args)
    NestedSequenceGenerator.new(*args)
  end

  # @private
  class TopLevelSequenceGenerator < SequenceGenerator #:nodoc:
    include TopLevel
  end

  def SequenceGenerator.top_level(*args)
    TopLevelSequenceGenerator.new(*args)
  end

end
