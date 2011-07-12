require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

shared_examples_for 'a compiled parser with a negative semantic predicate' do
  include CompilerSpecHelper

  subject { compiled_parser }

  let(:reference_parser) { combinator_parser grammar }

  context 'with a nested match rule' do
    let(:grammar) { define_grammar do
      rule(:num) { semantic_disallow(/\d+/, '_.to_i > 200') }
    end }
    it { should parse('123a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
    it { should parse('451a').failing.like reference_parser }

    context 'with a label' do
      let(:grammar) { define_grammar do
        rule(:digits) { semantic_disallow(label(:num, /\d+/), 'num.to_i > 200') }
      end }
      it { should parse('123a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
      it { should parse('451a').failing.like reference_parser }
    end
  end

  context 'with a nested apply rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { semantic_disallow :digit, '_.to_i > 200' }
      rule(:digit) { match(/\d+/) }
    end }
    it { should parse('123a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
    it { should parse('451a').failing.like reference_parser }

    context 'with a label' do
      let(:grammar) { define_grammar do
        rule(:num) { semantic_disallow(label(:num, :digits), 'num.to_i > 200') }
        rule(:digits) { match(/\d+/) }
      end }
      it { should parse('123a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
      it { should parse('451a').failing.like reference_parser }
    end
  end

  context 'with a nested choice rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        semantic_disallow(
          match(/[[:alpha:]]+/) | match(/[[:digit:]]+/),
          '_.size > 2'
        )
      end
    end }

    it { should parse('12abc').succeeding.like reference_parser }
    it { should parse('abc123').failing.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested sequence rule' do
    let(:grammar) { define_grammar do
      rule :assignment do
        semantic_disallow(
          match(/\w+/) & match('=') & match(/\w+/),
          '|l,_,r| l == r'
        )
      end
    end }
    it { should parse('451a=123a ').succeeding.like reference_parser }
    it { should parse('451a=451a ').failing.like reference_parser }

    context 'with labels' do
      let(:grammar) { define_grammar do
        rule :assignment do
          semantic_disallow(
            label(:lt, /\w+/) & match('=') & label(:rt, /\w+/),
            'lt == rt'
          )
        end
      end }
      it { should parse('451a=123a ').succeeding.like reference_parser }
      it { should parse('451a=451a ').failing.like reference_parser }
    end
  end

  context 'with a nested optional rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        semantic_disallow(optional(/\w+/), '|_| _.empty?')
      end
    end }
    it { should parse('    ').failing.like reference_parser }
    it { should parse('foo ').succeeding.like reference_parser }
  end

  context 'with a nested zero-or-more rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        semantic_disallow(zero_or_more(/\w/), '|_| _.size > 3')
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('food').failing.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }
  end

  context 'with a nested one-or-more rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        semantic_disallow(one_or_more(/\w/), '|_| _.size > 3')
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('food').failing.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested list rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        semantic_disallow(list(/\w+/, /,/, 1, nil), '|_| _.size > 3')
      end
    end }
    it { should parse('a,bc,d ').succeeding.like reference_parser }
    it { should parse('a,b,c,d').failing.like reference_parser }
    it { should parse('  ').failing.like reference_parser }
  end

  context 'with a nested apply rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { semantic_disallow :digit, '_.to_i > 200' }
      rule(:digit) { match /\d+/ }
    end }
    it { should parse('123a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
    it { should parse('451a').failing.like reference_parser }
  end

  context 'with a nested token rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        semantic_disallow(token(/\w+/), '_.size > 5')
      end
    end }
    it { should parse('abc12 ').succeeding.like reference_parser }
    it { should parse('      ').failing.like reference_parser }
    it { should parse('abc123').failing.like reference_parser }
  end
end
