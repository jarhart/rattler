shared_examples_for 'a compiled parser with a skip' do
  include CompilerSpecHelper

  subject { compiled_parser }

  let(:reference_parser) { combinator_parser grammar }

  context 'with a nested match rule' do
    let(:grammar) { define_grammar do
      rule(:ws) { skip(/\s+/) }
    end }
    it { should parse('   foo').succeeding.like reference_parser }
    it { should parse('hi').failing.like reference_parser }
  end

  context 'with a nested apply rule' do
    let(:grammar) { define_grammar do
      rule(:spaces) { match(/\s+/) }
      rule(:ws) { skip(:spaces) }
    end }
    it { should parse('   foo').succeeding.like reference_parser }
    it { should parse('hi').failing.like reference_parser }
  end

  context 'with a nested assert rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { skip(assert(/\d/)) }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested disallow rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { skip(disallow(/\d/)) }
    end }
    it { should parse('    ').succeeding.like reference_parser }
    it { should parse('451a').failing.like reference_parser }
  end

  context 'with a nested EOF rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { skip(eof) }
    end }
    it { should parse('foo').failing.like reference_parser }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').from(3).succeeding.like reference_parser }
  end

  context 'with a nested "E" symbol rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { skip(e) }
    end }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').succeeding.like reference_parser }
  end

  context 'with a nested choice rule' do
    let(:grammar) { define_grammar do
      rule(:ws) do
        skip(match(/\s+/) | match(/\#[^\n]*/))
      end
    end }
    it { should parse('   # hi there ').succeeding.twice.like reference_parser }
    it { should parse('hi').failing.like reference_parser }
  end

  context 'with a nested sequence rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        skip(match(/[[:alpha:]]+/) & match(/[[:digit:]]+/))
      end
    end }
    it { should parse('foo42!').succeeding.like reference_parser }
    it { should parse('val=x').failing.like reference_parser }
  end

  context 'with a nested optional rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        skip(optional(/\w+/))
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }
  end

  context 'with a nested zero-or-more rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        skip(zero_or_more(/\w/))
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }
  end

  context 'with a nested one-or-more rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        skip(one_or_more(/\w/))
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested repeat rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        skip(repeat(/\w/, 2, 4))
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('abcde ').succeeding.like reference_parser }
    it { should parse('a ').failing.like reference_parser }

    context 'with optional bounds' do
      let(:grammar) { define_grammar do
        rule :foo do
          skip(repeat(/\w+/, 0, 1))
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end

    context 'with zero-or-more bounds' do
      let(:grammar) { define_grammar do
        rule :foo do
          skip(repeat(/\w/, 0, 4))
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('abcde ').succeeding.like reference_parser }
      it { should parse('  ').succeeding.like reference_parser }
    end

    context 'with one-or-more bounds' do
      let(:grammar) { define_grammar do
        rule :foo do
          skip(repeat(/\w/, 1, 4))
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('abcde ').succeeding.like reference_parser }
      it { should parse('  ').failing.like reference_parser }
    end
  end

  context 'with a nested apply rule' do
    let(:grammar) { define_grammar do
      rule(:digits) { match(/\d+/) }
      rule(:foo) { skip(:digits) }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('hi').failing.like reference_parser }
  end
end
