require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

shared_examples_for 'a compiled parser with a skip' do
  include CompilerSpecHelper
  include RuntimeParserSpecHelper

  subject { compiled_parser }

  let(:reference_parser) { combinator_parser grammar }

  let(:grammar) { Rattler::Grammar::Grammar[Rattler::Parsers::RuleSet[*rules]] }

  context 'with a nested match rule' do
    let(:rules) { [
      rule(:ws) { skip(/\s+/) }
    ] }
    it { should parse('   foo').succeeding.like reference_parser }
    it { should parse('hi').failing.like reference_parser }
  end

  context 'with a nested apply rule' do
    let(:rules) { [
      rule(:spaces) { match(/\s+/) },
      rule(:ws) { skip(:spaces) }
    ] }
    it { should parse('   foo').succeeding.like reference_parser }
    it { should parse('hi').failing.like reference_parser }
  end

  context 'with a nested assert rule' do
    let(:rules) { [
      rule(:foo) { skip(assert(/\d/)) }
    ] }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested disallow rule' do
    let(:rules) { [
      rule(:foo) { skip(disallow(/\d/)) }
    ] }
    it { should parse('    ').succeeding.like reference_parser }
    it { should parse('451a').failing.like reference_parser }
  end

  context 'with a nested EOF rule' do
    let(:rules) { [
      rule(:foo) { skip(eof) }
    ] }
    it { should parse('foo').failing.like reference_parser }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').from(3).succeeding.like reference_parser }
  end

  context 'with a nested "E" symbol rule' do
    let(:rules) { [
      rule(:foo) { skip(e) }
    ] }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').succeeding.like reference_parser }
  end

  context 'with a nested choice rule' do
    let(:rules) { [
      rule(:ws) do
        skip(match(/\s+/) | match(/\#[^\n]*/))
      end
    ] }
    it { should parse('   # hi there ').succeeding.twice.like reference_parser }
    it { should parse('hi').failing.like reference_parser }
  end

  context 'with a nested sequence rule' do
    let(:rules) { [
      rule(:foo) {
        skip(match(/[[:alpha:]]+/) & match(/[[:digit:]]+/))
      }
    ] }
    it { should parse('foo42!').succeeding.like reference_parser }
    it { should parse('val=x').failing.like reference_parser }
  end

  context 'with a nested optional rule' do
    let(:rules) { [
      rule(:foo) {
        skip(match(/\w+/).optional)
      }
    ] }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }
  end

  context 'with a nested zero-or-more rule' do
    let(:rules) { [
      rule(:foo) {
        skip(match(/\w/).zero_or_more)
      }
    ] }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }
  end

  context 'with a nested one-or-more rule' do
    let(:rules) { [
      rule(:foo) {
        skip(match(/\w/).one_or_more)
      }
    ] }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested repeat rule' do
    let(:rules) { [
      rule(:foo) {
        skip(match(/\w/).repeat(2, 4))
      }
    ] }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('abcde ').succeeding.like reference_parser }
    it { should parse('a ').failing.like reference_parser }

    context 'with optional bounds' do
      let(:rules) { [
        rule(:foo) {
          skip(match(/\w+/).repeat(0, 1))
        }
      ] }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end

    context 'with zero-or-more bounds' do
      let(:rules) { [
        rule(:foo) {
          skip(match(/\w/).repeat(0, 4))
        }
      ] }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('abcde ').succeeding.like reference_parser }
      it { should parse('  ').succeeding.like reference_parser }
    end

    context 'with one-or-more bounds' do
      let(:rules) { [
        rule(:foo) {
          skip(match(/\w/).repeat(1, 4))
        }
      ] }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('abcde ').succeeding.like reference_parser }
      it { should parse('  ').failing.like reference_parser }
    end
  end

  context 'with a nested apply rule' do
    let(:rules) { [
      rule(:digits) { match(/\d+/) },
      rule(:foo) { skip(:digits) }
    ] }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('hi').failing.like reference_parser }
  end
end
