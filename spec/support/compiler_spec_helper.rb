require 'strscan'

module CompilerSpecHelper
  
  ParserBase = Rattler::Runtime::RecursiveDescentParser
  
  def define_parser(&block)
    Rattler::Parsers.define(&block)
  end
  
  def compile_parser(&block)
    Rattler::BackEnd::Compiler.
      compile_parser(ParserBase, define_parser(&block))
  end
  
  def compile(rules=nil, &block)
    Compile.new(rules || define_parser(&block))
  end
  
  class Compile
    def initialize(rules)
      @rules = rules
    end
    def description
      'compile the parser'
    end
    def matches?(target)
      @compiled_parser = target.compile_parser(ParserBase, @rules)
      !@compiled_parser.nil?
    end
    def failure_message_for_should
      "expected Compiler to compile the parser"
    end
    def test_parsing(test_input)
      CompileTestParsing.new(@rules, test_input)
    end
  end
  
  class CompileTestParsing < Compile
    def initialize(rules, test_input)
      super rules
      @rule_name = @rules.first.name
      @repeat = 1
      @test_input = test_input
    end
    def description
      super + ' to equivalent parsing code'
    end
    def as(rule_name)
      @rule_name = rule_name
      self
    end
    def twice
      repeating(2).times
    end
    def repeating(n)
      @repeat = n
      self
    end
    def times
      self
    end
    def matches?(target)
      if super
        scanner = StringScanner.new(@test_input)
        parser = @compiled_parser.new(@test_input)
        @repeat.times do
          @expected_result = normalize @rules[@rule_name].parse(scanner, @rules)
          @actual_result = normalize parser.match(@rule_name)
          @expected_pos = scanner.pos
          @actual_pos = parser.pos
          @correct_result = @expected_result == @actual_result
          @correct_pos = @expected_pos == @actual_pos
          return false unless @correct_result && @correct_pos
        end
      end
    end
    def failure_message_for_should
      if @compiled_parser
        "parsing #{@test_input.inspect}\n" +
        if @correct_result
          "incorrect parse position\n" +
          "expected: #{@expected_pos}\n" +
          "     got: #{@actual_pos}"
        else
          "incorrect result\n" +
          "expected: #{@expected_result.inspect}\n" +
          "     got: #{@actual_result.inspect}"
        end
      else
        super
      end
    end
    private
    def normalize(result)
      result.nil? ? false : result
    end
  end
  
end
