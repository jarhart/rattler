require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class SequenceGenerator < ExprGenerator #:nodoc:
    include NestedSubGenerating

    include Rattler::Parsers

    def gen_basic(sequence, scope = ParserScope.empty)
      scope = scope.nest
      with_backtracking do
        if sequence.capture_count == 1 and sequence.children.last.capturing?
          @g.intersperse_nl(sequence, ' &&') do |child|
            scope = gen_capturing(child, scope) { gen_nested child, :basic, scope }
          end
        else
          sequence.each do |child|
            @g.suffix(' &&') { scope = gen_capturing child, scope }.newline
          end
          @g << result_expr(sequence, scope)
        end
      end
    end

    def gen_assert(sequence, scope = ParserScope.empty)
      scope = scope.nest
      expr :block do
        lookahead do
          @g.block("#{result_name} = begin") do
            sequence.each do |_|
              @g.suffix(' &&') { scope = gen_matching _, scope }.newline
            end
            @g << "true"
          end
          @g.newline
        end
        @g << result_name
      end
    end

    def gen_disallow(sequence, scope = ParserScope.empty)
      scope = scope.nest
      expr :block do
        lookahead do
          @g.block("#{result_name} = !begin") do
            @g.intersperse_nl(sequence, ' &&') do |_|
              scope = gen_matching _, scope
            end
          end
          @g.newline
        end
        @g << result_name
      end
    end

    def gen_dispatch_action(sequence, code, scope = ParserScope.empty)
      scope = scope.nest
      gen_action_code(sequence, scope) do |new_scope|
        code.bind new_scope, result_array_expr(sequence, new_scope)
      end
    end

    def gen_direct_action(sequence, code, scope = ParserScope.empty)
      scope = scope.nest
      gen_action_code(sequence, scope) do |new_scope|
        expr = code.bind new_scope
        "(#{expr})"
      end
    end

    def gen_token(sequence, scope = ParserScope.empty)
      scope = scope.nest
      with_backtracking do
        sequence.each do |_|
          @g.suffix(' &&') { scope = gen_matching _, scope }.newline
        end
        @g << "@scanner.string[#{saved_pos_name}...(@scanner.pos)]"
      end
    end

    def gen_skip(sequence, scope = ParserScope.empty)
      scope = scope.nest
      with_backtracking do
        sequence.each do |_|
          @g.suffix(' &&') { scope = gen_matching _, scope }.newline
        end
        @g << "true"
      end
    end

    private

    def gen_matching(child, scope)
      if child.labeled?
        var_name = capture_name(scope) {|new_scope| scope = new_scope }
        @g.surround("(#{var_name} = ", ')') { gen_nested child, :basic, scope }
      else
        gen_nested child, :intermediate_skip, scope
      end
      labeled_scope(child, scope)
    end

    def gen_capturing(child, scope)
      if child.capturing?
        if block_given?
          yield
        else
          var_name = capture_name(scope) {|new_scope| scope = new_scope }
          @g.surround("(#{var_name} = ", ')') { gen_nested child, :basic, scope }
        end
      else
        gen_nested child, :intermediate, scope
      end
      labeled_scope(child, scope)
    end

    def labeled_scope(child, scope)
      if child.labeled?
        scope.bind(child.label => last_capture_name(scope))
      else
        scope
      end
    end

    def with_backtracking
      expr :block do
        (@g << "#{saved_pos_name} = @scanner.pos").newline
        @g.block 'begin' do
          yield
        end
        @g.block ' || begin' do
          (@g << "@scanner.pos = #{saved_pos_name}").newline << 'false'
        end
      end
    end

    def result_expr(sequence, scope)
      case scope.captures.size
      when 0 then 'true'
      when 1 then scope.captures[0]
      else result_array_expr(sequence, scope)
      end
    end

    def result_array_expr(sequence, scope)
      if sequence.any? {|_| Apply === _ }
        "select_captures(#{capture_names_expr(scope)})"
      else
        capture_names_expr(scope)
      end
    end

    def gen_action_code(sequence, scope)
      with_backtracking do
        for child in sequence
          @g.suffix(' &&') { scope = gen_capturing child, scope }.newline
        end
        @g << yield(scope)
      end
    end

    def capture_names_expr(scope)
      '[' + scope.captures.join(', ') + ']'
    end

    def capture_name(scope)
      new_scope = scope.capture("r#{sequence_level}_#{scope.captures.size}")
      yield new_scope
      last_capture_name(new_scope)
    end

    def last_capture_name(scope)
      scope.captures.last
    end

    attr_reader :capture_names

    def saved_pos_name
      "p#{sequence_level}"
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
