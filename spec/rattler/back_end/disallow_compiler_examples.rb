shared_examples_for 'a compiled parser with a disallow' do
  include CompilerSpecHelper

  subject { compiled_parser }

  let(:reference_parser) { combinator_parser grammar }

  context 'with a nested match rule' do
    let(:grammar) { define_grammar do
      rule(:word) { disallow /\w+/ }
    end }
    it { should parse('   ').succeeding.like reference_parser }
    it { should parse('abc123  ').failing.like reference_parser }
  end

  context 'with a nested eof rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { disallow(eof) }
    end }
    it { should parse('foo').succeeding.like reference_parser }
    it { should parse('').failing.like reference_parser }
    it { should parse('foo').from(3).failing.like reference_parser }
  end

  context 'with a nested choice rule' do
    let(:grammar) { define_grammar do
      rule(:word) { disallow(match(/[[:alpha:]]/) | match(/[[:digit:]]/)) }
    end }
    it { should parse('   ').succeeding.like reference_parser }
    it { should parse('abc123  ').failing.like reference_parser }
  end

  context 'with a nested sequence rule' do
    let(:grammar) { define_grammar do
      rule(:word) { disallow(match(/[[:alpha:]]+/) & match(/[[:digit:]]+/)) }
    end }
    it { should parse('   ').succeeding.like reference_parser }
    it { should parse('abc123  ').failing.like reference_parser }
  end

  context 'with a nested optional rule' do
    let(:grammar) { define_grammar do
      rule(:word) { disallow(optional(/\w+/)) }
    end }
    it { should parse('   ').failing.like reference_parser }
    it { should parse('abc123  ').failing.like reference_parser }
  end

  context 'with a nested zero_or_more rule' do
    let(:grammar) { define_grammar do
      rule(:word) { disallow(zero_or_more(/\w/)) }
    end }
    it { should parse('   ').failing.like reference_parser }
    it { should parse('abc123  ').failing.like reference_parser }
  end

  context 'with a nested one_or_more rule' do
    let(:grammar) { define_grammar do
      rule(:word) { disallow(one_or_more(/\w/)) }
    end }
    it { should parse('   ').succeeding.like reference_parser }
    it { should parse('abc123  ').failing.like reference_parser }
  end

  context 'with a nested repeat rule' do
    let(:grammar) { define_grammar do
      rule(:word) { disallow(repeat(/\w/, 2, nil)) }
    end }
    it { should parse('a ').succeeding.like reference_parser }
    it { should parse('abc123 ').failing.like reference_parser }

    context 'with zero-or-more bounds' do
      let(:grammar) { define_grammar do
        rule(:word) { disallow(repeat(/\w/, 0, nil)) }
      end }
      it { should parse('   ').failing.like reference_parser }
      it { should parse('abc123  ').failing.like reference_parser }

      context 'with an upper bound' do
        let(:grammar) { define_grammar do
          rule(:word) { disallow(repeat(/\w/, 0, 2)) }
        end }
        it { should parse('   ').failing.like reference_parser }
        it { should parse('abc123  ').failing.like reference_parser }
      end
    end

    context 'with one-or-more bounds' do
      let(:grammar) { define_grammar do
        rule(:word) { disallow(repeat(/\w/, 1, nil)) }
      end }
      it { should parse('   ').succeeding.like reference_parser }
      it { should parse('abc123  ').failing.like reference_parser }

      context 'with an upper bound' do
        let(:grammar) { define_grammar do
          rule(:word) { disallow(repeat(/\w/, 1, 2)) }
        end }
        it { should parse('   ').succeeding.like reference_parser }
        it { should parse('abc123  ').failing.like reference_parser }
      end
    end
  end

  context 'with a nested list rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        disallow list(/\w+/, /[,;]/, 2, nil)
      end
    end }
    it { should parse('foo  ').succeeding.like reference_parser }
    it { should parse('foo,bar;baz  ').failing.like reference_parser }

    context 'with an upper bound' do
      let(:grammar) { define_grammar do
        rule :foo do
          disallow list(/\w+/, /[,;]/, 2, 4)
        end
      end }
      it { should parse('foo  ').succeeding.like reference_parser }
      it { should parse('foo,bar;baz  ').failing.like reference_parser }
    end

    context 'with a non-capturing parser' do
      let(:grammar) { define_grammar do
        rule :foo do
          disallow list(skip(/\w+/), /[,;]/, 2, nil)
        end
      end }
      it { should parse('foo  ').succeeding.like reference_parser }
      it { should parse('foo,bar;baz  ').failing.like reference_parser }

      context 'with an upper bound' do
        let(:grammar) { define_grammar do
          rule :foo do
            disallow list(skip(/\w+/), /[,;]/, 2, 4)
          end
        end }
        it { should parse('foo  ').succeeding.like reference_parser }
        it { should parse('foo,bar;baz  ').failing.like reference_parser }
      end
    end
  end

  context 'with a nested apply rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { match :word }
      rule(:word) { disallow /\w+/ }
    end }
    it { should parse('   ').succeeding.like reference_parser }
    it { should parse('abc123  ').failing.like reference_parser }
  end

  context 'with a nested dispatch-action rule' do
    let(:grammar) { define_grammar do
      rule(:word) { disallow(dispatch_action(/\w+/)) }
    end }
    it { should parse('   ').succeeding.like reference_parser }
    it { should parse('abc123  ').failing.like reference_parser }
  end

  context 'with a nested token rule' do
    let(:grammar) { define_grammar do
      rule(:word) { disallow(token(match(/\w+/))) }
    end }
    it { should parse('   ').succeeding.like reference_parser }
    it { should parse('abc123  ').failing.like reference_parser }
  end

  context 'with a nested skip rule' do
    let(:grammar) { define_grammar do
      rule(:word) { disallow(skip(/\w+/)) }
    end }
    it { should parse('   ').succeeding.like reference_parser }
    it { should parse('abc123  ').failing.like reference_parser }
  end
end
