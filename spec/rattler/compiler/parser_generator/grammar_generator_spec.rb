require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Parsers
include Rattler::Grammar

describe Rattler::Compiler::ParserGenerator::GrammarGenerator do

  include ParserGeneratorSpecHelper

  describe '#generate' do

    context 'given a grammar with a :grammar_name option' do

      let(:grammar) { Grammar.new(rules, :grammar_name => 'ExprGrammar') }

      let(:rules) { RuleSet[Rule[:a, Match['a']]] }

      it 'generates a grammar module with a CLI' do
        trim_lines(generated_code {|g| g.generate grammar }).strip.
        should == (<<-CODE).strip
# @private
module ExprGrammar #:nodoc:

  # @private
  def start_rule #:nodoc:
    :a
  end

  # @private
  def match_a #:nodoc:
    apply :match_a!
  end

  # @private
  def match_a! #:nodoc:
    @scanner.scan("a") ||
    fail { :a }
  end

end

if __FILE__ == $0
  require 'rubygems'
  require 'rattler'
  Rattler::Util::GrammarCLI.run(ExprGrammar)
end
        CODE
      end
    end

    context 'given a grammar with a :parser_name option' do

      let(:grammar) { Grammar.new(rules, :parser_name => 'ExprParser') }

      let(:rules) { RuleSet[Rule[:a, Match['a']]] }

      it 'generates a parser module with a CLI' do
        trim_lines(generated_code {|g| g.generate grammar }).strip.
        should == (<<-CODE).strip
# @private
class ExprParser < Rattler::Runtime::PackratParser #:nodoc:

  # @private
  def start_rule #:nodoc:
    :a
  end

  # @private
  def match_a #:nodoc:
    apply :match_a!
  end

  # @private
  def match_a! #:nodoc:
    @scanner.scan("a") ||
    fail { :a }
  end

end

if __FILE__ == $0
  require 'rubygems'
  require 'rattler'
  Rattler::Util::ParserCLI.run(ExprParser)
end
        CODE
      end
    end
  end

  def trim_lines(s)
    s.each_line.map {|_| "#{_.rstrip}\n" }.join
  end

end
