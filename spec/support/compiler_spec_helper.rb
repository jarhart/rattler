require 'strscan'

module CompilerSpecHelper

  def define_grammar(&block)
    Rattler::Grammar::Grammar.new(Rattler::Parsers.define(&block))
  end

  def combinator_parser(g)
    Rattler::Parsers::CombinatorParser.as_class(g.rules.first, g.rules)
  end

  RSpec::Matchers.define :parse do |source|
    match do |parser_class|
      parser = parser_class.new(source)
      @repeat ||= 1
      actual_results = (1..@repeat).map { parser.parse or false }
      if @other_parser
        expected_results = (1..@repeat).map { @other_parser.parse or false }
        if mismatch = expected_results.zip(actual_results).find {|a, b| a != b }
          @wrong_result = true
          @expected_result, @actual_result = mismatch
        end
        @expected_pos = @other_parser.pos
        @actual_pos = parser.pos
        @wrong_pos = @expected_pos != @actual_pos
      end
      @wrong_fail = @should_succeed && actual_results.any? {|_| !_ }
      @wrong_success = @should_fail && actual_results.any? {|_| _ }
      not (@wrong_result or @wrong_fail or @wrong_success)
    end

    chain :succeeding do |*args|
      @repeat = args.shift unless args.empty?
      @should_succeed = true
    end

    chain :failing do
      @should_fail = true
    end

    chain :like do |other_parser_class|
      @other_parser = other_parser_class.new(source)
    end

    chain :twice do
      @repeat = 2
    end

    chain(:times) {} # syntactic sugar

    failure_message_for_should do |parser_class|
      m = "exected compiled parser to parse #{source.inspect}"
      m << " like reference parser" if @other_parser
      m << "\n"
      if @wrong_result
        m << "incorrect result\n" \
          << "expected: #{@expected_result.inspect}\n" \
          << "     got: #{@actual_result.inspect}"
      elsif @wrong_pos
        m << "incorrect parse position\n" \
          << "expected: #{@expected_pos}\n" \
          << "     got: #{@actual_pos}"
      elsif @wrong_success
        m << "expected parse to fail"
      elsif @wrong_fail
        m << "expected parse to succeed"
      end
      m
    end
  end

end
