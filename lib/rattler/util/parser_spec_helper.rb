#
# = rattler/util/parser_spec_helper.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/util'

module Rattler::Util
  #
  # +ParserSpecHelper+ defines a fluent interface for writing RSpec examples
  # for parsers.
  #
  # @example
  #
  #   require 'rattler/grammar/grammar_parser'
  #   require 'rattler/util/parser_spec_helper'
  #
  #   describe Rattler::Grammar::GrammarParser do
  #     include Rattler::Util::ParserSpecHelper
  #
  #     describe '#match(:var_name)' do
  #       it 'recognizes variable names' do
  #         matching(' fooBar ').as(:var_name).should result_in('fooBar').at(7)
  #         matching(' FooBar ').as(:var_name).should fail.with_message('variable name expected')
  #       end
  #     end
  #   end
  #
  # @author Jason Arhart
  #
  module ParserSpecHelper

    # Return a parse result to be matched using #result_in or #fail
    #
    #   parsing(source)
    #   parsing(source).from(pos)
    #
    def parsing(source)
      Parsing.new(parser(source))
    end

    # Return a match result to be matched using #result_in or #fail
    #
    #   matching(source).as(rule_name)
    #   matching(source).as(rule_name).from(pos)
    #
    def matching(source)
      Matching.new(parser(source))
    end

    def parser(source)
      (self.respond_to?(:parser_class) ? parser_class : described_class).new(source)
    end

    # Expect parse to succeed.
    #
    #   parsing(source).should result_in(result)
    #
    # Passes if parsing _source_ succeeds returning _result_.
    #
    #   parsing(source).should result_in(result).at(pos)
    #
    # Passes if parsing _source_ succeeds returning
    # _result_ with the parse position at _pos_.
    #
    # @return [Matcher]
    RSpec::Matchers.define :result_in do |expected|
      match do |target|
        (target.result == expected) and
        (not @expected_pos or
          target.pos == @expected_pos) and
        (not @expected_bindings or
          @expected_bindings.all?{|k, v| target.scope[k] == v })
      end

      chain :at do |pos|
        @expected_pos = pos
      end

      chain :with_scope do |bindings|
        @expected_bindings = bindings
      end

      failure_message_for_should do |target|
        if target.result != expected
          <<-MESSAGE
incorrect parse result
expected #{expected.inspect}
     got #{target.result.inspect}
MESSAGE
        else
          <<-MESSAGE
incorrect parse position
expected #{@expected_pos.inspect}
     got #{target.pos.inspect}
MESSAGE
        end
      end
    end

    # Expect parse to fail.
    #
    #   parsing(source).as(rule_name).should fail
    #
    # Passes if parsing _source_ with _parser_class_ fails.
    #
    #   parsing(source).as(rule_name).should fail.at(pos)
    #
    # Passes if parsing _source_ with _parser_class_ fails with the parse
    # position at _pos_
    #
    # @return [Matcher]
    RSpec::Matchers.define :fail do
      match do |target|
        !target.result &&
        (!@expected_message || (target.failure.message == @expected_message)) &&
        (!@expected_pos || (target.failure.pos == @expected_pos))
      end

      chain :with_message do |message|
        @expected_message = message
      end

      chain :at do |pos|
        @expected_pos = pos
      end

      failure_message_for_should do |target|
        if target.result
          "expected parse to fail but got #{target.result.inspect}"
        elsif @expected_message && (target.failure.message != @expected_message)
          <<-MESSAGE
incorrect failure message
expected #{@expected_message.inspect}
     got #{target.failure.message.inspect}
MESSAGE
        else
          <<-MESSAGE
incorrect failure position
expected #{@expected_pos.inspect}
     got #{target.failure.pos.inspect}
MESSAGE
        end
      end
    end

    # @private
    class Parsing #:nodoc:
      def initialize(parser)
        @parser = parser
      end
      attr_reader :parser
      def from(pos)
        @parser.pos = pos
        self
      end
      def result
        @result ||= @parser.parse
      end
      def pos
        @parser.pos
      end
      def failure
        @parser.failure
      end
    end

    # @private
    class Matching < Parsing #:nodoc:
      def as(rule_name)
        @rule_name = rule_name
        self
      end
      def result
        @result ||= @parser.match(@rule_name)
      end
    end

  end
end
