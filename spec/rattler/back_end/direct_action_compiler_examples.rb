require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

shared_examples_for 'a compiled parser with a direct action' do
  include CompilerSpecHelper

  subject { compiled_parser }

  let(:reference_parser) { combinator_parser grammar }

  context 'with a nested match rule' do
    let(:grammar) { define_grammar do
      rule(:num) { direct_action(/\d+/, '|_| _.to_i') }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }

    context 'with a label' do
      let(:grammar) { define_grammar do
        rule(:digits) { direct_action(label(:num, /\d+/), 'num.to_i') }
      end }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end
  end

  context 'with a nested apply rule' do
    let(:grammar) { define_grammar do
      rule(:digit) { match(/\d/) }
      rule(:foo) { direct_action :digit, '|_| _.to_i' }
    end }
    it { should parse('451 ').twice.succeeding.like reference_parser }
    it { should parse('hi').failing.like reference_parser }

    context 'with a label' do
      let(:grammar) { define_grammar do
        rule(:digits) { match(/\d+/) }
        rule(:num) { direct_action(label(:num, :digits), '|_| _.to_i') }
      end }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end
  end

  context 'with a nested assert rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { direct_action(assert(/\d/), ':digit') }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested disallow rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { direct_action(disallow(/\d/), ':nondigit') }
    end }
    it { should parse('    ').succeeding.like reference_parser }
    it { should parse('451a').failing.like reference_parser }
  end

  context 'with a nested EOF rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { direct_action(eof, ':eof') }
    end }
    it { should parse('foo').failing.like reference_parser }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').from(3).succeeding.like reference_parser }
  end

  context 'with a nested "E" symbol rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { direct_action(e, ':e') }
    end }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').succeeding.like reference_parser }
  end

  context 'with a nested choice rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        direct_action(
          match(/[[:alpha:]]+/) | match(/[[:digit:]]+/),
          '|_| _.size'
        )
      end
    end }

    it { should parse('abc123').succeeding.like reference_parser }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested sequence rule' do
    let(:grammar) { define_grammar do
      rule :assignment do
        direct_action(
          match(/[[:alpha:]]+/) & match('=') & match(/[[:digit:]]+/),
          '|l,_,r| "#{r} -> #{l}"'
        )
      end
    end }

    it { should parse('val=42 ').succeeding.like reference_parser }
    it { should parse('val=x').failing.like reference_parser }

    context 'with labels' do
      let(:grammar) { define_grammar do
        rule :assignment do
          direct_action(
            label(:name, /[[:alpha:]]+/) & match('=') & label(:value, /[[:digit:]]+/),
            '"#{value} -> #{name}"'
          )
        end
      end }
      it { should parse('val=42 ').succeeding.like reference_parser }
    end
  end

  context 'with a nested optional rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        direct_action(optional(/\w+/), '|_| _.size')
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }
  end

  context 'with a nested zero-or-more rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        direct_action(zero_or_more(/\w/), '|_| _.size')
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }
  end

  context 'with a nested one-or-more rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        direct_action(one_or_more(/\w/), '|_| _.size')
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested repeat rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        direct_action(repeat(/\w/, 2, 4), '|_| _.size')
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('abcde ').succeeding.like reference_parser }
    it { should parse('a ').failing.like reference_parser }

    context 'with optional bounds' do
      let(:grammar) { define_grammar do
        rule :foo do
          direct_action(repeat(/\w+/, 0, 1), '|_| _.size')
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end

    context 'with zero-or-more bounds' do
      let(:grammar) { define_grammar do
        rule :foo do
          direct_action(repeat(/\w/, 0, nil), '|_| _.size')
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end

    context 'with one-or-more bounds' do
      let(:grammar) { define_grammar do
        rule :foo do
          direct_action(repeat(/\w/, 1, nil), '|_| _.size')
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end
  end

  context 'with a nested list rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        direct_action(list(/\w+/, /,/, 1, nil), '|_| _.reduce(:+)')
      end
    end }
    it { should parse('a,bc,d ').succeeding.like reference_parser }
    it { should parse('  ').failing.like reference_parser }
  end

  context 'with a nested apply rule' do
    let(:grammar) { define_grammar do
      rule(:digit) { match /\d/ }
      rule(:foo) { direct_action :digit, '|_| _.to_i' }
    end }
    it { should parse('451a').succeeding.twice.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested token rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        direct_action(token(/\w+/), '|_| _.size')
      end
    end }
    it { should parse('abc123').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested skip rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        direct_action(skip(/\w+/), '42' )
      end
    end }
    it { should parse('abc123').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end
end
