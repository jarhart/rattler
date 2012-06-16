require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path('assert_compiler_examples', File.dirname(__FILE__))
require File.expand_path('disallow_compiler_examples', File.dirname(__FILE__))
require File.expand_path('semantic_action_compiler_examples', File.dirname(__FILE__))
require File.expand_path('attributed_sequence_compiler_examples', File.dirname(__FILE__))
require File.expand_path('token_compiler_examples', File.dirname(__FILE__))
require File.expand_path('skip_compiler_examples', File.dirname(__FILE__))

shared_examples_for 'a compiled parser' do
  include CompilerSpecHelper
  include RuntimeParserSpecHelper

  it_behaves_like 'a compiled parser with an assert'
  it_behaves_like 'a compiled parser with a disallow'
  it_behaves_like 'a compiled parser with a semantic action'
  it_behaves_like 'a compiled parser with an attributed sequence'
  it_behaves_like 'a compiled parser with a token'
  it_behaves_like 'a compiled parser with a skip'

  subject { compiled_parser }

  let(:reference_parser) { combinator_parser grammar }

  let(:grammar) { Rattler::Parsers::Grammar[Rattler::Parsers::RuleSet[*rules]] }

  ########## match ##########
  context 'with a match rule' do
    let(:rules) { [
      rule(:digit) { match(/\d/) }
    ] }
    it { should parse('451').succeeding.twice.like reference_parser }
    it { should parse(' 4').failing.like reference_parser }
    it { should parse('foo').failing.like reference_parser }
  end

  ########## choice ##########
  context 'with a choice rule' do
    let(:rules) { [
      rule(:atom) { match(/[[:alpha:]]+/) | match(/[[:digit:]]+/) }
    ] }
    it { should parse('abc123').succeeding.twice.like reference_parser }
    it { should parse('==').failing.like reference_parser }

    context 'with non-capturing parsers' do
      let(:rules) { [
        rule(:foo) { skip(/\s+/) | skip(/\{[^\}]*\}/) }
      ] }
      it { should parse('   foo').succeeding.like reference_parser }
      it { should parse('{foo}').succeeding.like reference_parser }
    end

    context 'with nested choices' do
      let(:rules) { [
        rule(:foo) {
          ( (match('a') | match('b')) \
          | (match('c') | match('d')) )
        }
      ] }
      it { should parse('abcd').succeeding(4).times.like reference_parser }
      it { should parse('123').failing.like reference_parser }
    end

    context 'with nested sequences' do
      let(:rules) { [
        rule(:foo) {
          ( match('a') & match('b') \
          | match('c') & match('d') )
        }
      ] }
      it { should parse('abcd').succeeding.twice.like reference_parser }
      it { should parse('123').failing.like reference_parser }
    end

    context 'with nested optional parsers' do
      let(:rules) { [
        rule(:foo) { match('a').optional | match('b').optional }
      ] }
      it { should parse('abcd').succeeding(3).times.like reference_parser }
      it { should parse('123').succeeding.like reference_parser }
    end
  end

  ########## sequence ##########
  context 'with a sequence rule' do
    let(:rules) { [
      rule(:assignment) {
        match(/[[:alpha:]]+/) & match('=') & match(/[[:digit:]]+/)
      }
    ] }
    it { should parse('val=42 ').succeeding.like reference_parser }
    it { should parse('val=x ').failing.like reference_parser }

    context 'with non-capturing parsers' do
      let(:rules) { [
        rule(:foo) {
          match(/[[:alpha:]]+/) & skip(/\s+/) & match(/[[:digit:]]+/)
        }
      ] }
      it { should parse('foo 42').succeeding.like reference_parser }
    end

    context 'with only one capturing parser' do
      let(:rules) { [
        rule(:foo) { skip(/\s+/) & match(/\w+/) }
      ] }
      it { should parse('  abc123').succeeding.like reference_parser }
    end

    context 'with no capturing parsers' do
      let(:rules) { [
        rule(:foo) { skip(/\s*/) & skip(/#[^\n]+/) }
      ] }
      it { should parse(' # foo').succeeding.like reference_parser }
    end

    context 'with an apply referencing a non-capturing rule' do
      let(:rules) { [
        rule(:foo) {
          match(/[[:alpha:]]+/) & match(:ws) & match(/[[:digit:]]+/)
        },
        rule(:ws) { skip(/\s+/) }
      ] }
      it { should parse('foo 42').succeeding.like reference_parser }
    end
  end

  ########## optional ##########
  context 'with an optional rule' do
    let(:rules) { [
      rule(:foo) { match(/\w+/).optional }
    ] }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }

    context 'with a non-capturing parser' do
      let(:rules) { [
        rule(:foo) { skip(/\w+/).optional }
      ] }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end
  end

  ########## zero-or-more ##########
  context 'with an zero-or-more rule' do
    let(:rules) { [
      rule(:foo) { match(/\w/).zero_or_more }
    ] }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }

    context 'with a non-capturing parser' do
      let(:rules) { [
        rule(:foo) { skip(/\w/).zero_or_more }
      ] }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end
  end

  ########## one-or-more ##########
  context 'with an one-or-more rule' do
    let(:rules) { [
      rule(:foo) { match(/\w/).one_or_more }
    ] }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }

    context 'with a non-capturing parser' do
      let(:rules) { [
        rule(:foo) { skip(/\w/).one_or_more }
      ] }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end
  end

  ########## repeat ##########
  context 'with a repeat rule' do
    let(:rules) { [
      rule(:foo) { match(/\w/).repeat(2, 4) }
    ] }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('abcde ').succeeding.like reference_parser }
    it { should parse('a ').failing.like reference_parser }

    context 'with no upper bound' do
      let(:rules) { [
        rule(:foo) { match(/\w/).repeat(2, nil) }
      ] }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('abcde ').succeeding.like reference_parser }
      it { should parse('a ').failing.like reference_parser }
    end

    context 'with a non-capturing parser' do
      let(:rules) { [
        rule(:foo) { skip(/\w/).repeat(2, 4) }
      ] }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('abcde ').succeeding.like reference_parser }
      it { should parse('a ').failing.like reference_parser }
    end

    context 'with a choice of capturing or non-capturing parsers' do
      let(:rules) { [
        rule(:foo) { (match(/a/) | skip(/b/)).repeat(2, 4) }
      ] }
      it { should parse('abac').succeeding.like reference_parser }
    end

    context 'with an attributed sequence with an action returning true' do
      let(:rules) { [
        rule(:foo) { (match(/\w/) >> semantic_action('true')).repeat(2, 4) }
      ] }
      it { should parse('abc ').succeeding.like reference_parser }
    end
  end

  ########## list ##########
  context 'given a list rule' do
    let(:rules) { [
      rule(:foo) { match(/\w+/).list(match(/[,;]/), 2, nil) }
    ] }
    it { should parse('foo  ').failing.like reference_parser }
    it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
    it { should parse('foo,bar,  ').succeeding.like reference_parser }

    context 'with an upper bound' do
      let(:rules) { [
        rule(:foo) { match(/\w+/).list(match(/[,;]/), 2, 4) }
      ] }
      it { should parse('foo  ').failing.like reference_parser }
      it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
      it { should parse('a,b,c,d,e  ').succeeding.like reference_parser }
      it { should parse('foo,bar,  ').succeeding.like reference_parser }
    end

    context 'with a non-capturing parser' do
      let(:rules) { [
        rule(:foo) { skip(/\w+/).list(match(/[,;]/), 2, nil) }
      ] }
      it { should parse('foo  ').failing.like reference_parser }
      it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
      it { should parse('foo,bar,  ').succeeding.like reference_parser }

      context 'with an upper bound' do
        let(:rules) { [
          rule(:foo) { skip(/\w+/).list(match(/[,;]/), 2, 4) }
        ] }
        it { should parse('foo  ').failing.like reference_parser }
        it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
        it { should parse('a,b,c,d,e  ').succeeding.like reference_parser }
        it { should parse('foo,bar,  ').succeeding.like reference_parser }
      end

      context 'with "zero-or-more" bounds' do
        let(:rules) { [
          rule(:foo) { skip(/\w+/).list(match(/[,;]/), 0, nil) }
        ] }
        it { should parse('  ').succeeding.like reference_parser }
        it { should parse('foo  ').succeeding.like reference_parser }
        it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
      end

      context 'with "one-or-more" bounds' do
        let(:rules) { [
          rule(:foo) { skip(/\w+/).list(match(/[,;]/), 1, nil) }
        ] }
        it { should parse('  ').failing.like reference_parser }
        it { should parse('foo  ').succeeding.like reference_parser }
        it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
      end
    end
  end

  ########## apply ##########
  context 'given an apply rule' do
    let(:rules) { [
      rule(:digit) { match /\d/ },
      rule(:foo) { match :digit }
    ] }
    it { should parse('451 ').twice.succeeding.like reference_parser }
    it { should parse('hi').failing.like reference_parser }
  end

  ########## eof ##########
  context 'given eof' do
    let(:rules) { [
      rule(:foo) { eof }
    ] }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').from(3).succeeding.like reference_parser }
    it { should parse('foo').failing.like reference_parser }
  end

  ########## E ##########
  context 'given "E" symbol' do
    let(:rules) { [
      rule(:foo) { e }
    ] }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').succeeding.like reference_parser }
  end
end
