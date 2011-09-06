require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

shared_examples_for 'a compiled parser with an attributed sequence' do
  include CompilerSpecHelper

  subject { compiled_parser }

  let(:reference_parser) { combinator_parser grammar }

  context 'with a single capture and a semantic action' do

    context 'when the action uses no parameters' do
      let(:grammar) { define_grammar do
        rule(:a) { match(/\d+/) >> semantic_action('42') }
      end }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end

    context 'when the action uses a parameter' do
      let(:grammar) { define_grammar do
        rule(:a) { match(/\d+/) >> semantic_action('|a| a.to_i') }
      end }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end

    context 'when the action uses "_"' do
      let(:grammar) { define_grammar do
        rule(:a) { match(/\d+/) >> semantic_action('_.to_i') }
      end }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end
  end

  context 'with a single capture and a node action' do
    let(:grammar) { define_grammar do
      rule(:a) { match(/\d+/) >> node_action('Rattler::Runtime::ParseNode') }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }

    context 'when the action has node attributes' do
      let(:grammar) { define_grammar do
        rule(:a) do
          match(/\d+/) >> node_action('Rattler::Runtime::ParseNode', :node_attrs => {:name => "FOO"})
        end
      end }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end
  end

  context 'with a capturing nonterminal and a node action' do
    let(:grammar) { define_grammar do
      rule(:a) { match(:b) >> node_action('Rattler::Runtime::ParseNode') }
      rule(:b) { match(/\d+/) }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a non-capturing nonterminal and a node action' do
    let(:grammar) { define_grammar do
      rule(:a) { match(:b) >> node_action('Rattler::Runtime::ParseNode') }
      rule(:b) { skip(/\d+/) }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with multiple captures and a semantic action' do

    context 'when the action uses parameters' do
      let(:grammar) { define_grammar do
        rule(:a) do
          (match(/[a-z]+/) & match(/\d+/)) >> semantic_action('|a,b| b+a')
        end
      end }
      it { should parse('abc123').succeeding.like reference_parser }
      it { should parse('      ').failing.like reference_parser }
    end

    context 'when the action uses "_"' do
      let(:grammar) { define_grammar do
        rule(:a) do
          (match(/[a-z]+/) & match(/\d+/)) >> semantic_action('_.reverse')
        end
      end }
      it { should parse('abc123').succeeding.like reference_parser }
      it { should parse('      ').failing.like reference_parser }
    end
  end

  context 'with multiple captures and a node action' do
    let(:grammar) { define_grammar do
      rule(:a) do
        (match(/[a-z]+/) & match(/\d+/)) >> node_action('Rattler::Runtime::ParseNode')
      end
    end }
    it { should parse('abc123').succeeding.like reference_parser }
    it { should parse('      ').failing.like reference_parser }
  end

  context 'with a single labeled capture and a semantic action' do
    let(:grammar) { define_grammar do
      rule(:e) { label(:a, /\d+/) >> semantic_action('a.to_i') }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with multiple labeled captures and a semantic action' do
    let(:grammar) { define_grammar do
      rule(:e) do
        (label(:a, /[a-z]+/) & label(:b, /\d+/)) >> semantic_action('b + a')
      end
    end }
    it { should parse('abc123').succeeding.like reference_parser }
    it { should parse('      ').failing.like reference_parser }
  end

  context 'with a single labeled capture and a node action' do
    let(:grammar) { define_grammar do
      rule(:e) { label(:a, /\d+/) >> node_action('Rattler::Runtime::ParseNode') }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }

    context 'when the action has node attributes' do
      let(:grammar) { define_grammar do
        rule(:e) do
          label(:a, /\d+/) >> node_action('Rattler::Runtime::ParseNode', :node_attrs => {:name => "FOO"})
        end
      end }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end
  end

  context 'with multiple labeled captures and a node action' do
    let(:grammar) { define_grammar do
      rule(:e) do
        (label(:a, /[a-z]+/) & label(:b, /\d+/)) >> node_action('Rattler::Runtime::ParseNode')
      end
    end }
    it { should parse('abc123').succeeding.like reference_parser }
    it { should parse('      ').failing.like reference_parser }
  end
end
