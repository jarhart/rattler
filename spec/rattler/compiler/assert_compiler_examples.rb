require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

shared_examples_for 'a compiled parser with an assert' do
  include CompilerSpecHelper
  include RuntimeParserSpecHelper

  subject { compiled_parser }

  let(:reference_parser) { combinator_parser grammar }

  let(:grammar) { Rattler::Parsers::Grammar[Rattler::Parsers::RuleSet[*rules]] }

  context 'with a nested match rule' do
    let(:rules) { [
      rule(:word) { assert(/\w+/) }
    ] }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').failing.like reference_parser }
  end

  context 'with a nested eof rule' do
    let(:rules) { [
      rule(:foo) { assert(eof) }
    ] }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').from(3).succeeding.like reference_parser }
    it { should parse('foo').failing.like reference_parser }
  end

  context 'with a nested "E" symbol rule' do
    let(:rules) { [
      rule(:foo) { assert(e) }
    ] }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').succeeding.like reference_parser }
  end

  context 'with a nested choice rule' do
    let(:rules) { [
      rule(:word) { assert(match(/[[:alpha:]]+/) | match(/[[:digit:]]+/)) }
    ] }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').failing.like reference_parser }
  end

  context 'with a nested sequence rule' do
    let(:rules) { [
      rule(:word) { assert(match(/[[:alpha:]]+/) & match(/[[:digit:]]+/)) }
    ] }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').failing.like reference_parser }

    context 'with a semantic action' do

      context 'when the expression has parameters' do
        let(:rules) { [
          rule(:a) { assert(match(/\d+/) >> semantic_action('|a| a.to_i * 2')) }
        ] }
        it { should parse('451a').succeeding.like reference_parser }
        it { should parse('    ').failing.like reference_parser }
      end

      context 'when the expression uses "_"' do

        context 'given a single capture' do
          let(:rules) { [
            rule(:a) { assert(match(/\d+/) >> semantic_action('_ * 2')) }
          ] }
          it { should parse('451a').succeeding.like reference_parser }
          it { should parse('    ').failing.like reference_parser }
        end

        context 'given multiple captures' do
          let(:rules) { [
            rule(:a) { assert(
              (match(/\d+/) & skip(/\s+/) & match(/\d+/)) >> semantic_action('_')
            ) }
          ] }
          it { should parse('23 42').succeeding.like reference_parser }
          it { should parse('     ').failing.like reference_parser }
        end
      end

      context 'when the expression uses labels' do
        let(:rules) { [
          rule(:a) { assert(label(:a, /\d+/) >> semantic_action('a.to_i * 2')) }
        ] }
        it { should parse('451a').succeeding.like reference_parser }
        it { should parse('    ').failing.like reference_parser }
      end
    end
  end

  context 'with a nested optional rule' do
    let(:rules) { [
      rule(:word) { assert(match(/\w+/).optional) }
    ] }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').succeeding.like reference_parser }
  end

  context 'with a nested zero-or-more rule' do
    let(:rules) { [
      rule(:word) { assert(match(/\w/).zero_or_more) }
    ] }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').succeeding.like reference_parser }
  end

  context 'with a nested one-or-more rule' do
    let(:rules) { [
      rule(:word) { assert(match(/\w/).one_or_more) }
    ] }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').failing.like reference_parser }
  end

  context 'with a nested repeat rule' do
    let(:rules) { [
      rule(:word) { assert(match(/\w/).repeat(2, nil)) }
    ] }
    it { should parse('abc123 ').succeeding.like reference_parser }
    it { should parse('a ').failing.like reference_parser }

    context 'with zero-or-more bounds' do
      let(:rules) { [
        rule(:word) { assert(match(/\w/).repeat(0, nil)) }
      ] }
      it { should parse('abc123  ').succeeding.like reference_parser }
      it { should parse('   ').succeeding.like reference_parser }

      context 'with an upper bound' do
        let(:rules) { [
          rule(:word) { assert(match(/\w/).repeat(0, 2)) }
        ] }
        it { should parse('abc123  ').succeeding.like reference_parser }
        it { should parse('   ').succeeding.like reference_parser }
      end
    end

    context 'with one-or-more bounds' do
      let(:rules) { [
        rule(:word) { assert(match(/\w/).repeat(1, nil)) }
      ] }
      it { should parse('abc123  ').succeeding.like reference_parser }
      it { should parse('   ').failing.like reference_parser }

      context 'with an upper bound' do
        let(:rules) { [
          rule(:word) { assert(match(/\w/).repeat(1, 2)) }
        ] }
        it { should parse('abc123  ').succeeding.like reference_parser }
        it { should parse('   ').failing.like reference_parser }
      end
    end
  end

  context 'with a nested list rule' do
    let(:rules) { [
      rule(:foo) { assert(match(/\w+/).list(match(/[,;]/), 2, nil)) }
    ] }
    it { should parse('foo  ').failing.like reference_parser }
    it { should parse('foo,bar;baz  ').succeeding.like reference_parser }

    context 'with an upper bound' do
      let(:rules) { [
        rule(:foo) { assert(match(/\w+/).list(match(/[,;]/), 2, 4)) }
      ] }
      it { should parse('foo  ').failing.like reference_parser }
      it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
    end

    context 'with a non-capturing parser' do
      let(:rules) { [
        rule(:foo) { assert(skip(/\w+/).list(match(/[,;]/), 2, nil)) }
      ] }
      it { should parse('foo  ').failing.like reference_parser }
      it { should parse('foo,bar;baz  ').succeeding.like reference_parser }

      context 'with an upper bound' do
        let(:rules) { [
          rule(:foo) { assert skip(/\w+/).list(match(/[,;]/), 2, 4) }
        ] }
        it { should parse('foo  ').failing.like reference_parser }
        it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
      end
    end
  end

  context 'with a nested apply rule' do
    let(:rules) { [
      rule(:foo) { match(:word) },
      rule(:word) { assert(/\w+/) }
    ] }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').failing.like reference_parser }
  end

  context 'with a nested semantic action' do
    let(:rules) { [
      rule(:a) { assert(semantic_action('42')) }
    ] }
    it { should parse('anything').succeeding.like reference_parser }
  end

  context 'with a nested attributed sequence' do

    context 'with a single capture and a semantic action' do

      context 'when the action uses a parameter' do
        let(:rules) { [
          rule(:a) { assert(match(/\d+/) >> semantic_action('|a| a.to_i')) }
        ] }
        it { should parse('451a').succeeding.like reference_parser }
        it { should parse('    ').failing.like reference_parser }
      end

      context 'when the action uses "_"' do
        let(:rules) { [
          rule(:a) { assert(match(/\d+/) >> semantic_action('_.to_i')) }
        ] }
        it { should parse('451a').succeeding.like reference_parser }
        it { should parse('    ').failing.like reference_parser }
      end
    end

    context 'with multiple captures and a semantic action' do

      context 'when the action uses parameters' do
        let(:rules) { [
          rule(:a) { assert(
            (match(/[a-z]+/) & match(/\d+/)) >> semantic_action('|a,b| b+a')
          ) }
        ] }
        it { should parse('abc123').succeeding.like reference_parser }
        it { should parse('      ').failing.like reference_parser }
      end

      context 'when the action uses "_"' do
        let(:rules) { [
          rule(:a) { assert(
            (match(/[a-z]+/) & match(/\d+/)) >> semantic_action('_.reverse')
          ) }
        ] }
        it { should parse('abc123').succeeding.like reference_parser }
        it { should parse('      ').failing.like reference_parser }
      end
    end

    context 'with a single labeled capture and a semantic action' do
      let(:rules) { [
        rule(:e) { assert(label(:a, /\d+/) >> semantic_action('a.to_i')) }
      ] }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end

    context 'with multiple labeled captures and a semantic action' do
      let(:rules) { [
        rule(:e) { assert(
          (label(:a, /[a-z]+/) & label(:b, /\d+/)) >> semantic_action('b + a')
        ) }
      ] }
      it { should parse('abc123').succeeding.like reference_parser }
      it { should parse('      ').failing.like reference_parser }
    end
  end

  context 'with a nested token rule' do
    let(:rules) { [
      rule(:word) { assert(token(/\w+/)) }
    ] }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').failing.like reference_parser }
  end

  context 'with a nested skip rule' do
    let(:rules) { [
      rule(:word) { assert(skip(/\w+/)) }
    ] }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').failing.like reference_parser }
  end
end
