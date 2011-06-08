require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

shared_examples_for 'a compiled parser with an assert' do
  include CompilerSpecHelper

  subject { compiled_parser }

  let(:reference_parser) { combinator_parser grammar }

  context 'with a nested match rule' do
    let(:grammar) { define_grammar do
      rule(:word) { assert /\w+/ }
    end }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').failing.like reference_parser }
  end

  context 'with a nested eof rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { assert(eof) }
    end }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').from(3).succeeding.like reference_parser }
    it { should parse('foo').failing.like reference_parser }
  end

  context 'with a nested "E" symbol rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { assert(e) }
    end }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').succeeding.like reference_parser }
  end

  context 'with a nested choice rule' do
    let(:grammar) { define_grammar do
      rule(:word) { assert(match(/[[:alpha:]]+/) | match(/[[:digit:]]+/)) }
    end }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').failing.like reference_parser }
  end

  context 'with a nested sequence rule' do
    let(:grammar) { define_grammar do
      rule(:word) { assert(match(/[[:alpha:]]+/) & match(/[[:digit:]]+/)) }
    end }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').failing.like reference_parser }
  end

  context 'with a nested optional rule' do
    let(:grammar) { define_grammar do
      rule(:word) { assert(optional(/\w+/)) }
    end }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').succeeding.like reference_parser }
  end

  context 'with a nested zero-or-more rule' do
    let(:grammar) { define_grammar do
      rule(:word) { assert(zero_or_more(/\w/)) }
    end }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').succeeding.like reference_parser }
  end

  context 'with a nested one-or-more rule' do
    let(:grammar) { define_grammar do
      rule(:word) { assert(one_or_more(/\w/)) }
    end }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').failing.like reference_parser }
  end

  context 'with a nested repeat rule' do
    let(:grammar) { define_grammar do
      rule(:word) { assert(repeat(/\w/, 2, nil)) }
    end }
    it { should parse('abc123 ').succeeding.like reference_parser }
    it { should parse('a ').failing.like reference_parser }

    context 'with zero-or-more bounds' do
      let(:grammar) { define_grammar do
        rule(:word) { assert(repeat(/\w/, 0, nil)) }
      end }
      it { should parse('abc123  ').succeeding.like reference_parser }
      it { should parse('   ').succeeding.like reference_parser }

      context 'with an upper bound' do
        let(:grammar) { define_grammar do
          rule(:word) { assert(repeat(/\w/, 0, 2)) }
        end }
        it { should parse('abc123  ').succeeding.like reference_parser }
        it { should parse('   ').succeeding.like reference_parser }
      end
    end

    context 'with one-or-more bounds' do
      let(:grammar) { define_grammar do
        rule(:word) { assert(repeat(/\w/, 1, nil)) }
      end }
      it { should parse('abc123  ').succeeding.like reference_parser }
      it { should parse('   ').failing.like reference_parser }

      context 'with an upper bound' do
        let(:grammar) { define_grammar do
          rule(:word) { assert(repeat(/\w/, 1, 2)) }
        end }
        it { should parse('abc123  ').succeeding.like reference_parser }
        it { should parse('   ').failing.like reference_parser }
      end
    end
  end

  context 'with a nested list rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        assert list(/\w+/, /[,;]/, 2, nil)
      end
    end }
    it { should parse('foo  ').failing.like reference_parser }
    it { should parse('foo,bar;baz  ').succeeding.like reference_parser }

    context 'with an upper bound' do
      let(:grammar) { define_grammar do
        rule :foo do
          assert list(/\w+/, /[,;]/, 2, 4)
        end
      end }
      it { should parse('foo  ').failing.like reference_parser }
      it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
    end

    context 'with a non-capturing parser' do
      let(:grammar) { define_grammar do
        rule :foo do
          assert list(skip(/\w+/), /[,;]/, 2, nil)
        end
      end }
      it { should parse('foo  ').failing.like reference_parser }
      it { should parse('foo,bar;baz  ').succeeding.like reference_parser }

      context 'with an upper bound' do
        let(:grammar) { define_grammar do
          rule :foo do
            assert list(skip(/\w+/), /[,;]/, 2, 4)
          end
        end }
        it { should parse('foo  ').failing.like reference_parser }
        it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
      end
    end
  end

  context 'with a nested apply rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { match :word }
      rule(:word) { assert /\w+/ }
    end }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').failing.like reference_parser }
  end

  context 'with a nested dispatch-action rule' do
    let(:grammar) { define_grammar do
      rule(:word) { assert(dispatch_action(/\w+/)) }
    end }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').failing.like reference_parser }
  end

  context 'with a nested token rule' do
    let(:grammar) { define_grammar do
      rule(:word) { assert(token(match(/\w+/))) }
    end }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').failing.like reference_parser }
  end

  context 'with a nested skip rule' do
    let(:grammar) { define_grammar do
      rule(:word) { assert(skip(/\w+/)) }
    end }
    it { should parse('abc123  ').succeeding.like reference_parser }
    it { should parse('   ').failing.like reference_parser }
  end
end
