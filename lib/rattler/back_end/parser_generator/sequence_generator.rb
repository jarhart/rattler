require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class SequenceGenerator < ExprGenerator #:nodoc:
    include NestedSubGenerating

    include Rattler::Parsers

    def initialize(*args)
      super
      @capture_names = []
    end

    def gen_basic(sequence, scope={})
      with_backtracking do
        if sequence.capture_count == 1 and sequence.children.last.capturing?
          @g.intersperse_nl(sequence, ' &&') do |child|
            scope = gen_capturing(child, scope) { gen_nested child, :basic, scope }
          end
        else
          sequence.each do |child|
            @g.suffix(' &&') { scope = gen_capturing child, scope }.newline
          end
          @g << result_expr(sequence)
        end
      end
    end

    def gen_assert(sequence, scope={})
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

    def gen_disallow(sequence, scope={})
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

    def gen_dispatch_action(sequence, code, scope={})
      gen_action_code(sequence, scope) do |new_scope|
        code.bind new_scope, result_array_expr(sequence)
      end
    end

    def gen_direct_action(sequence, code, scope={})
      gen_action_code(sequence, scope) do |new_scope|
        "(#{code.bind new_scope, @capture_names})"
      end
    end

    def gen_token(sequence, scope={})
      with_backtracking do
        sequence.each do |_|
          @g.suffix(' &&') { scope = gen_matching _, scope }.newline
        end
        @g << "@scanner.string[#{saved_pos_name}...(@scanner.pos)]"
      end
    end

    def gen_skip(sequence, scope={})
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
        @g.surround("(#{capture_name} = ", ')') { gen_nested child, :basic, scope }
      else
        gen_nested child, :intermediate_skip, scope
      end
      child.labeled? ? scope.merge(child.label => last_capture_name) : scope
    end

    def gen_capturing(child, scope)
      if child.capturing?
        if block_given?
          yield
        else
          @g.surround("(#{capture_name} = ", ')') { gen_nested child, :basic, scope }
        end
      else
        gen_nested child, :intermediate, scope
      end
      child.labeled? ? scope.merge(child.label => last_capture_name) : scope
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

    def result_expr(sequence)
      case @capture_names.size
      when 0 then 'true'
      when 1 then @capture_names[0]
      else result_array_expr(sequence)
      end
    end

    def result_array_expr(sequence)
      if sequence.any? {|_| Apply === _ }
        "select_captures(#{capture_names_expr})"
      else
        capture_names_expr
      end
    end

    def gen_action_code(sequence, scope={})
      with_backtracking do
        for child in sequence
          @g.suffix(' &&') { scope = gen_capturing child, scope }.newline
        end
        @g << yield(scope)
      end
    end

    def capture_names_expr
      '[' + @capture_names.join(', ') + ']'
    end

    def capture_name
      @capture_names << "r#{sequence_level}_#{@capture_names.size}"
      @capture_names.last
    end

    def last_capture_name
      @capture_names.last
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
