require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/compiler/shared_compiler_examples')

describe Rattler::Compiler do
  include CompilerSpecHelper
  include RuntimeParserSpecHelper

  describe '.compile_parser result' do

    let :compiled_parser do
      described_class.compile_parser compiled_parser_base, grammar, :no_optimize => true
    end

    let(:compiled_parser_base) { Rattler::Runtime::RecursiveDescentParser }

    it_behaves_like 'a compiled parser'
  end

  describe '.compile_parser' do

    let(:grammar) { Rattler::Grammar::Grammar[Rattler::Parsers::RuleSet[*rules]] }

    context 'given parse rules' do

      let(:rules) { [
        rule(:word) { match(/\w+/) },
        rule(:space) { match(/\s*/) }
      ] }

      let(:parser_base) { Rattler::Runtime::RecursiveDescentParser }

      let(:result) { described_class.compile_parser(parser_base, grammar) }

      it 'compiles a match_xxx method for each rule' do
        result.should have_method(:match_word)
        result.should have_method(:match_space)
      end
    end
  end

  describe '.compile' do

    let(:grammar) { Rattler::Grammar::Grammar[Rattler::Parsers::RuleSet[*rules]] }

    context 'given parse rules' do

      let(:rules) { [
        rule(:word) { match(/\w+/) },
        rule(:space) { match(/\s*/) }
      ] }

      let(:target_module) { Module.new }

      before { described_class.compile(target_module, grammar) }

      it 'compiles a match_xxx method for each rule' do
        target_module.should have_method(:match_word)
        target_module.should have_method(:match_space)
      end
    end
  end

  def have_method(rule_name)
    be_method_defined(rule_name)
  end

end
