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

    def gen_basic_nested(sequence)
      atomic_block { gen_basic_top_level sequence }
    end

    def gen_basic_top_level(sequence)
      with_backtracking do
        if sequence.capture_count == 1 and sequence.children.last.capturing?
          @g.intersperse_nl(sequence, ' &&') do |child|
            gen_capturing(child) { generate child }
          end
        else
          sequence.each { |_| @g.suffix(' &&') { gen_capturing _ }.newline }
          @g << result_expr(sequence)
        end
      end
    end

    def gen_assert_nested(sequence)
      atomic_block { gen_assert_top_level sequence }
    end

    def gen_assert_top_level(sequence)
      lookahead do
        @g.block("#{result_name} = begin") do
          sequence.each do |_|
            @g.suffix(' &&') { generate _, :intermediate_skip }.newline
          end
          @g << "true"
        end
        @g.newline
      end
      @g << result_name
    end

    def gen_disallow_nested(sequence)
      atomic_block { gen_disallow_top_level sequence }
    end

    def gen_disallow_top_level(sequence)
      lookahead do
        @g.block("#{result_name} = !begin") do
          @g.intersperse_nl(sequence, ' &&') do |_|
            generate _, :intermediate_skip
          end
        end
        @g.newline
      end
      @g << result_name
    end

    def gen_dispatch_action_nested(sequence, target, method_name)
      atomic_block do
        gen_dispatch_action_top_level sequence, target, method_name
      end
    end

    def gen_dispatch_action_top_level(sequence, target, method_name)
      gen_action_code(sequence) do |labeled|
        dispatch_action_result(target, method_name,
          :array_expr => result_array_expr(sequence), :labeled => labeled)
      end
    end

    def gen_direct_action_nested(sequence, action)
      atomic_block { gen_direct_action_top_level sequence, action }
    end

    def gen_direct_action_top_level(sequence, action)
      gen_action_code(sequence) do |labeled|
        direct_action_result(action,
          :bind_args => @capture_names, :labeled => labeled)
      end
    end

    def gen_token_nested(sequence)
      atomic_block { gen_token_top_level sequence }
    end

    def gen_token_top_level(sequence)
      with_backtracking do
        sequence.each do |_|
          @g.suffix(' &&') { generate _, :intermediate_skip }.newline
        end
        @g << "@scanner.string[#{saved_pos_name}...(@scanner.pos)]"
      end
    end

    def gen_skip_nested(sequence)
      atomic_block { gen_skip_top_level sequence }
    end

    def gen_skip_top_level(sequence)
      with_backtracking do
        sequence.each do |_|
          @g.suffix(' &&') { generate _, :intermediate_skip }.newline
        end
        @g << "true"
      end
    end

    private

    def gen_capturing(child)
      if child.capturing?
        if block_given?
          yield
        else
          @g.surround("(#{capture_name} = ", ')') { generate child }
        end
      else
        generate child, :intermediate
      end
    end

    def with_backtracking
      (@g << "#{saved_pos_name} = @scanner.pos").newline
      @g.block 'begin' do
        yield
      end
      @g.block ' || begin' do
        (@g << "@scanner.pos = #{saved_pos_name}").newline << 'false'
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

    def gen_action_code(sequence)
      with_backtracking do
        labeled = {}
        for child in sequence
          @g.suffix(' &&') { gen_capturing child }.newline
          labeled[child.label] = last_capture_name if child.labeled?
        end
        @g << yield(labeled)
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
