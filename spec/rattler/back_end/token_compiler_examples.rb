require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

shared_examples_for 'a compiled parser with a token' do
  include CompilerSpecHelper
  include RuntimeParserSpecHelper

  subject { compiled_parser }

  let(:reference_parser) { combinator_parser grammar }

  let(:grammar) { Rattler::Grammar::Grammar[Rattler::Parsers::RuleSet[*rules]] }

  context 'with a nested match rule' do
    let(:rules) { [
      rule(:digits) { token(match(/\d+/)) }
    ] }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('hi').failing.like reference_parser }
  end

  context 'with a nested apply rule' do
    let(:rules) { [
      rule(:digit) { match(/\d/) },
      rule(:foo) { token(:digit) }
    ] }
    it { should parse('451 ').twice.succeeding.like reference_parser }
    it { should parse('hi').failing.like reference_parser }

    context 'with a label' do
      let(:rules) { [
        rule(:digits) { match(/\d+/) },
        rule(:num) { token(label(:num, :digits)) }
      ] }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end
  end

  context 'with a nested assert rule' do
    let(:rules) { [
      rule(:foo) { token(assert(/\d/)) }
    ] }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested disallow rule' do
    let(:rules) { [
      rule(:foo) { token(disallow(/\d/)) }
    ] }
    it { should parse('    ').succeeding.like reference_parser }
    it { should parse('451a').failing.like reference_parser }
  end

  context 'with a nested EOF rule' do
    let(:rules) { [
      rule(:foo) { token(eof) }
    ] }
    it { should parse('foo').failing.like reference_parser }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').from(3).succeeding.like reference_parser }
  end

  context 'with a nested "E" symbol rule' do
    let(:rules) { [
      rule(:foo) { token(e) }
    ] }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').succeeding.like reference_parser }
  end

  context 'with a nested choice rule' do
    let(:rules) { [
      rule(:atom) {
        token(match(/[[:alpha:]]+/) | match(/[[:digit:]]+/))
      }
    ] }

    it { should parse('abc123 ').succeeding.like reference_parser }
    it { should parse('==').failing.like reference_parser }

    context 'with non-capturing choices' do
      let(:rules) { [
        rule(:atom) {
          token(skip(/[[:alpha:]]+/) | match(/[[:digit:]]+/))
        }
      ] }
      it { should parse('abc123 ').succeeding.like reference_parser }
      it { should parse('==').failing.like reference_parser }
    end
  end

  context 'with a nested sequence rule' do
    let(:rules) { [
      rule(:atom) {
        token(match(/[[:alpha:]]+/) & match(/[[:digit:]]+/))
      }
    ] }

    it { should parse('foo42!').succeeding.like reference_parser }
    it { should parse('val=x').failing.like reference_parser }

    context 'with non-capturing parsers' do
      let(:rules) { [
        rule(:foo) {
          token(match(/[[:alpha:]]+/) & skip(/\s+/) & match(/[[:digit:]]+/))
        }
      ] }
      it { should parse('foo 42').succeeding.like reference_parser }
      it { should parse('foo bar').failing.like reference_parser }
    end
  end

  context 'with a nested optional rule' do
    let(:rules) { [
      rule(:foo) {
        token(match(/\w+/).optional)
      }
    ] }

    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }

    context 'with a non-capturing rule' do
      let(:rules) { [
        rule(:foo) {
          token(skip(/\w+/).optional)
        }
      ] }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end
  end

  context 'with a nested zero-or-more rule' do
    let(:rules) { [
      rule(:foo) {
        token(match(/\w/).zero_or_more)
      }
    ] }

    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }

    context 'with a non-capturing rule' do
      let(:rules) { [
        rule(:foo) {
          token(skip(/\w/).zero_or_more)
        }
      ] }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end
  end

  context 'with a nested one-or-more rule' do
    let(:rules) { [
      rule(:foo) {
        token(match(/\w/).one_or_more)
      }
    ] }

    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }

    context 'with a non-capturing rule' do
      let(:rules) { [
        rule(:foo) {
          token(skip(/\w/).one_or_more)
        }
      ] }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end
  end

  context 'with a nested repeat' do
    let(:rules) { [
      rule(:foo) {
        token(match(/\w/).repeat(2, 4))
      }
    ] }

    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('abcde').succeeding.like reference_parser }
    it { should parse('a ').failing.like reference_parser }

    context 'with a non-capturing rule' do
      let(:rules) { [
        rule(:foo) {
          token(skip(/\w/).repeat(2, 4))
        }
      ] }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('abcde').succeeding.like reference_parser }
      it { should parse('a ').failing.like reference_parser }
    end

    context 'with optional bounds' do
      let(:rules) { [
        rule(:foo) {
          token(match(/\w+/).repeat(0, 1))
        }
      ] }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end

    context 'with zero-or-more bounds' do
      let(:rules) { [
        rule(:foo) {
          token(skip(/\w/).repeat(0, nil))
        }
      ] }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('  ').succeeding.like reference_parser }
    end

    context 'with one-or-more bounds' do
      let(:rules) { [
        rule(:foo) {
          token(skip(/\w/).repeat(1, nil))
        }
      ] }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('a ').succeeding.like reference_parser }
      it { should parse('  ').failing.like reference_parser }
    end
  end

  context 'with a nested apply rule' do
    let(:rules) { [
      rule(:foo) { token(:digits) },
      rule(:digits) { match(/\d+/) }
    ] }

    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('hi').failing.like reference_parser }

    context 'applying a non-capturing rule' do
      let(:rules) { [
        rule(:foo) { token(:digits) },
        rule(:digits) { skip(/\d+/) }
      ] }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('hi').failing.like reference_parser }
    end
  end

  context 'with a nested skip rule' do
    let(:rules) { [
      rule(:foo) { token(skip(/\w+/)) }
    ] }
    it { should parse('abc123').succeeding.like reference_parser }
    it { should parse('  ').failing.like reference_parser }
  end
end
