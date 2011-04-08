shared_examples_for 'a compiled parser with a dispatch action' do
  include CompilerSpecHelper

  subject { compiled_parser }

  let(:reference_parser) { combinator_parser grammar }

  context 'with a nested match rule' do
    let(:grammar) { define_grammar do
      rule(:digits) { dispatch_action(/\d+/) }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }

    context 'with a label' do
      let(:grammar) { define_grammar do
        rule(:digits) { dispatch_action(label(:num, /\d+/)) }
      end }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end
  end

  context 'with a nested apply rule' do
    let(:grammar) { define_grammar do
      rule(:digit) { match(/\d/) }
      rule(:foo) { dispatch_action :digit }
    end }
    it { should parse('451 ').twice.succeeding.like reference_parser }
    it { should parse('hi').failing.like reference_parser }

    context 'with a label' do
      let(:grammar) { define_grammar do
        rule(:digits) { match(/\d+/) }
        rule(:num) { dispatch_action(label(:num, :digits)) }
      end }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end
  end

  context 'with a nested assert rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { dispatch_action(assert(/\d/)) }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested disallow rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { dispatch_action(disallow(/\d/)) }
    end }
    it { should parse('    ').succeeding.like reference_parser }
    it { should parse('451a').failing.like reference_parser }
  end

  context 'with a nested eof rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { dispatch_action(eof) }
    end }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').from(3).succeeding.like reference_parser }
    it { should parse('foo').failing.like reference_parser }
  end

  context 'with a nested "E" symbol rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { dispatch_action(e) }
    end }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').succeeding.like reference_parser }
  end

  context 'with a nested choice rule' do
    let(:grammar) { define_grammar do
      rule :atom do
        dispatch_action(match(/[[:alpha:]]+/) | match(/[[:digit:]]+/))
      end
    end }

    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested sequence rule' do
    let(:grammar) { define_grammar do
      rule :assignment do
        dispatch_action(
          match(/[[:alpha:]]+/) &
          match('=') &
          match(/[[:digit:]]+/)
        )
      end
    end }

    it { should parse('val=42 ').succeeding.like reference_parser }
    it { should parse('val=x').failing.like reference_parser }

    context 'with labels' do
      let(:grammar) { define_grammar do
        rule :assignment do
          dispatch_action(
            label(:name, /[[:alpha:]]+/) &
            match('=') &
            label(:value, /[[:digit:]]+/)
          )
        end
      end }
      it { should parse('val=42 ').succeeding.like reference_parser }
    end
  end

  context 'with a nested optional rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        dispatch_action(optional(/\w+/))
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }
  end

  context 'with a nested zero-or-more rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        dispatch_action(zero_or_more(/\w/))
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }
  end

  context 'with a nested one-or-more rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        dispatch_action(one_or_more(/\w/))
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested repeat rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        dispatch_action(repeat(/\w/, 2, 4))
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('abcde ').succeeding.like reference_parser }
    it { should parse('a ').failing.like reference_parser }

    context 'with optional bounds' do
      let(:grammar) { define_grammar do
        rule :foo do
          dispatch_action(repeat(/\w+/, 0, 1))
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end

    context 'with zero-or-more bounds' do
      let(:grammar) { define_grammar do
        rule :foo do
          dispatch_action(repeat(/\w/, 0, nil))
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end

    context 'with one-or-more bounds' do
      let(:grammar) { define_grammar do
        rule :foo do
          dispatch_action(repeat(/\w/, 1, nil))
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end
  end

  context 'with a nested list rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        dispatch_action(list(/\w+/, /,/, 1, nil))
      end
    end }
    it { should parse('a,bc,d ').succeeding.like reference_parser }
    it { should parse('  ').failing.like reference_parser }
  end

  context 'with a nested apply rule' do
    let(:grammar) { define_grammar do
      rule(:digit) { match /\d/ }
      rule(:foo) { dispatch_action :digit }
    end }
    it { should parse('451a').succeeding.twice.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested token rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        dispatch_action(token(match(/\w+/)))
      end
    end }
    it { should parse('abc123').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested skip rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        dispatch_action(skip(/\w+/))
      end
    end }
    it { should parse('abc123').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end
end
