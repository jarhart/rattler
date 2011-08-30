require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

shared_examples_for 'a compiled parser with a semantic action' do
  include CompilerSpecHelper

  subject { compiled_parser }

  let(:reference_parser) { combinator_parser grammar }

  context 'when the expression has no parameters' do
    let(:grammar) { define_grammar do
      rule(:a) { semantic_action('42') }
    end }
    it { should parse('anything').succeeding.like reference_parser }
  end

  context 'when the expression has parameters' do
    let(:grammar) { define_grammar do
      rule(:a) { match(/\d+/) & semantic_action('|a| a.to_i * 2') }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'when the expression uses "_"' do

    context 'given a single capture' do
      let(:grammar) { define_grammar do
        rule(:a) { match(/\d+/) & semantic_action('_ * 2') }
      end }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end

    context 'given multiple captures' do
      let(:grammar) { define_grammar do
        rule(:a) do
          match(/\d+/) & skip(/\s+/) & match(/\d+/) & semantic_action('_')
        end
      end }
      it { should parse('23 42').succeeding.like reference_parser }
      it { should parse('     ').failing.like reference_parser }
    end
  end

  context 'when the expression uses labels' do
    let(:grammar) { define_grammar do
      rule(:a) { label(:a, /\d+/) & semantic_action('a.to_i * 2') }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

end
