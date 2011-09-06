require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  # @private
  module SequenceGenerating #:nodoc:
    include NestedSubGenerating

    def gen_assert(sequence, scope = ParserScope.empty)
      expr :block do
        lookahead do
          @g.block("#{result_name} = begin") do
            gen_children_matching(sequence, scope.nest) do |last_child, scope|
              @g.suffix(' &&') { gen_nested last_child, :intermediate_skip, scope }
              @g.newline << 'true'
            end
          end
          @g.newline
        end
        @g << result_name
      end
    end

    def gen_disallow(sequence, scope = ParserScope.empty)
      expr :block do
        lookahead do
          @g.block("#{result_name} = !begin") do
            gen_children_matching(sequence, scope.nest) do |last_child, scope|
              gen_nested last_child, :intermediate_skip, scope
            end
          end
          @g.newline
        end
        @g << result_name
      end
    end

    def gen_token(sequence, scope = ParserScope.empty)
      with_backtracking do
        gen_children_matching(sequence, scope.nest) do |last_child, scope|
          @g.suffix(' &&') { gen_nested last_child, :intermediate_skip, scope }
          @g.newline << "@scanner.string[#{saved_pos_name}...(@scanner.pos)]"
        end
      end
    end

    def gen_skip(sequence, scope = ParserScope.empty)
      with_backtracking do
        gen_children_matching(sequence, scope.nest) do |last_child, scope|
          @g.suffix(' &&') { gen_matching last_child, scope }
          @g.newline << 'true'
        end
      end
    end

    protected

    def gen_children_capturing(sequence, scope)
      @g.intersperse_nl(sequence, ' &&') do |child|
        if child.equal? sequence.children.last
          yield child, scope
        else
          scope = gen_capturing(child, scope)
        end
      end
    end

    def gen_children_matching(sequence, scope)
      @g.intersperse_nl(sequence, ' &&') do |child|
        if child.equal? sequence.children.last
          yield child, scope
        elsif sequence.semantic?
          scope = gen_capturing(child, scope)
        else
          scope = gen_matching(child, scope)
        end
      end
    end

    def gen_capturing(child, scope)
      if child.capturing?
        scope = capture_child(child, scope)
      else
        gen_nested child, :intermediate, scope
      end
      scope
    end

    def gen_matching(child, scope)
      if child.labeled? and child.capturing?
        scope = capture_child(child, scope)
      else
        gen_nested child, :intermediate_skip, scope
      end
      scope
    end

    def capture_child(child, scope)
      scope = new_capture(child, scope) do |name|
        @g.surround("(#{name} = ", ')') { gen_nested child, :basic, scope }
      end
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

    def new_capture(child, scope)
      new_scope = scope.capture("r#{sequence_level}_#{scope.captures.size}")
      unless child.capturing_decidable?
        new_scope = new_scope.with_undecidable_captures
      end
      yield last_capture_name(new_scope)
      new_scope
    end

    def last_capture_name(scope)
      scope.captures.last
    end

    def saved_pos_name
      "p#{sequence_level}"
    end

  end
end
