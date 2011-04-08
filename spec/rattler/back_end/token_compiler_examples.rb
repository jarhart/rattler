shared_examples_for 'a compiled parser with a token' do
  include CompilerSpecHelper

  subject { compiled_parser }

  let(:reference_parser) { combinator_parser grammar }

  context 'with a nested match rule' do
    let(:grammar) { define_grammar do
      rule(:digits) { token(match(/\d+/)) }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('hi').failing.like reference_parser }
  end

  context 'with a nested apply rule' do
    let(:grammar) { define_grammar do
      rule(:digit) { match(/\d/) }
      rule(:foo) { token :digit }
    end }
    it { should parse('451 ').twice.succeeding.like reference_parser }
    it { should parse('hi').failing.like reference_parser }

    context 'with a label' do
      let(:grammar) { define_grammar do
        rule(:digits) { match(/\d+/) }
        rule(:num) { token(label(:num, :digits)) }
      end }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end
  end

  context 'with a nested assert rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { token(assert(/\d/)) }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested disallow rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { token(disallow(/\d/)) }
    end }
    it { should parse('    ').succeeding.like reference_parser }
    it { should parse('451a').failing.like reference_parser }
  end

  context 'with a nested EOF rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { token(eof) }
    end }
    it { should parse('foo').failing.like reference_parser }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').from(3).succeeding.like reference_parser }
  end

  context 'with a nested "E" symbol rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { token(e) }
    end }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').succeeding.like reference_parser }
  end

  context 'with a nested choice rule' do
    let(:grammar) { define_grammar do
      rule(:atom) do
        token(match(/[[:alpha:]]+/) | match(/[[:digit:]]+/))
      end
    end }

    it { should parse('abc123 ').succeeding.like reference_parser }
    it { should parse('==').failing.like reference_parser }

    context 'with non-capturing choices' do
      let(:grammar) { define_grammar do
        rule(:atom) do
          token(skip(/[[:alpha:]]+/) | match(/[[:digit:]]+/))
        end
      end }
      it { should parse('abc123 ').succeeding.like reference_parser }
      it { should parse('==').failing.like reference_parser }
    end
  end

  context 'with a nested sequence rule' do
    let(:grammar) { define_grammar do
      rule(:atom) do
        token(match(/[[:alpha:]]+/) & match(/[[:digit:]]+/))
      end
    end }

    it { should parse('foo42!').succeeding.like reference_parser }
    it { should parse('val=x').failing.like reference_parser }

    context 'with non-capturing parsers' do
      let(:grammar) { define_grammar do
        rule :foo do
          token(match(/[[:alpha:]]+/) & skip(/\s+/) & match(/[[:digit:]]+/))
        end
      end }
      it { should parse('foo 42').succeeding.like reference_parser }
      it { should parse('foo bar').failing.like reference_parser }
    end
  end

  context 'with a nested optional rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        token(optional(/\w+/))
      end
    end }

    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }

    context 'with a non-capturing rule' do
      let(:grammar) { define_grammar do
        rule :foo do
          token(optional(skip(/\w+/)))
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end
  end

  context 'with a nested zero-or-more rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        token(zero_or_more(/\w/))
      end
    end }

    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }

    context 'with a non-capturing rule' do
      let(:grammar) { define_grammar do
        rule :foo do
          token(zero_or_more(skip(/\w/)))
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end
  end

  context 'with a nested one-or-more rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        token(one_or_more(/\w/))
      end
    end }

    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }

    context 'with a non-capturing rule' do
      let(:grammar) { define_grammar do
        rule :foo do
          token(one_or_more(skip(/\w/)))
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end
  end

  context 'with a nested repeat' do
    let(:grammar) { define_grammar do
      rule :foo do
        token(repeat(/\w/, 2, 4))
      end
    end }

    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('abcde').succeeding.like reference_parser }
    it { should parse('a ').failing.like reference_parser }

    context 'with a non-capturing rule' do
      let(:grammar) { define_grammar do
        rule :foo do
          token(repeat(skip(/\w/), 2, 4))
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('abcde').succeeding.like reference_parser }
      it { should parse('a ').failing.like reference_parser }
    end

    context 'with optional bounds' do
      let(:grammar) { define_grammar do
        rule :foo do
          token(repeat(/\w+/, 0, 1))
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end

    context 'with zero-or-more bounds' do
      let(:grammar) { define_grammar do
        rule :foo do
          token(repeat(skip(/\w/), 0, nil))
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('  ').succeeding.like reference_parser }
    end

    context 'with one-or-more bounds' do
      let(:grammar) { define_grammar do
        rule :foo do
          token(repeat(skip(/\w/), 1, nil))
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('a ').succeeding.like reference_parser }
      it { should parse('  ').failing.like reference_parser }
    end
  end

  context 'with a nested apply rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { token(match(:digits)) }
      rule(:digits) { match(/\d+/) }
    end }

    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('hi').failing.like reference_parser }

    context 'applying a non-capturing rule' do
      let(:grammar) { define_grammar do
        rule(:foo) { token(match(:digits)) }
        rule(:digits) { skip(/\d+/) }
      end }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('hi').failing.like reference_parser }
    end
  end

  context 'with a nested dispatch-action rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { token(dispatch_action(/\w+/)) }
    end }
    it { should parse('abc123').succeeding.like reference_parser }
    it { should parse('  ').failing.like reference_parser }
  end

  context 'with a nested skip rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { token(skip(/\w+/)) }
    end }
    it { should parse('abc123').succeeding.like reference_parser }
    it { should parse('  ').failing.like reference_parser }
  end
end
