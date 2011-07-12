require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

shared_examples_for 'a compiled parser with a positive semantic predicate' do
  include CompilerSpecHelper

  subject { compiled_parser }

  let(:reference_parser) { combinator_parser grammar }

  context 'with a nested match rule' do
    let(:grammar) { define_grammar do
      rule(:num) { semantic_assert(/\d+/, '_.to_i > 200') }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
    it { should parse('123a').failing.like reference_parser }

    context 'with a label' do
      let(:grammar) { define_grammar do
        rule(:digits) { semantic_assert(label(:num, /\d+/), 'num.to_i > 200') }
      end }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
      it { should parse('123a').failing.like reference_parser }
    end
  end

  context 'with a nested apply rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { semantic_assert :digit, '_.to_i > 200' }
      rule(:digit) { match(/\d+/) }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
    it { should parse('123a').failing.like reference_parser }

    context 'with a label' do
      let(:grammar) { define_grammar do
        rule(:num) { semantic_assert(label(:num, :digits), 'num.to_i > 200') }
        rule(:digits) { match(/\d+/) }
      end }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
      it { should parse('123a').failing.like reference_parser }
    end
  end

  context 'with a nested choice rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        semantic_assert(
          match(/[[:alpha:]]+/) | match(/[[:digit:]]+/),
          '_.size > 2'
        )
      end
    end }

    it { should parse('abc123').succeeding.like reference_parser }
    it { should parse('12abc').failing.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested sequence rule' do
    let(:grammar) { define_grammar do
      rule :assignment do
        semantic_assert(
          match(/\w+/) & match('=') & match(/\w+/),
          '|l,_,r| l == r'
        )
      end
    end }
    it { should parse('451a=451a ').succeeding.like reference_parser }
    it { should parse('451a=123a ').failing.like reference_parser }

    context 'with labels' do
      let(:grammar) { define_grammar do
        rule :assignment do
          semantic_assert(
            label(:lt, /\w+/) & match('=') & label(:rt, /\w+/),
            'lt == rt'
          )
        end
      end }
      it { should parse('451a=451a ').succeeding.like reference_parser }
      it { should parse('451a=123a ').failing.like reference_parser }
    end
  end

  context 'with a nested optional rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        semantic_assert(optional(/\w+/), '|_| _.empty?')
      end
    end }
    it { should parse('foo ').failing.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }
  end

  context 'with a nested zero-or-more rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        semantic_assert(zero_or_more(/\w/), '|_| _.size < 4')
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('food').failing.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }
  end

  context 'with a nested one-or-more rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        semantic_assert(one_or_more(/\w/), '|_| _.size < 4')
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('food').failing.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
  end

  context 'with a nested list rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        semantic_assert(list(/\w+/, /,/, 1, nil), '|_| _.size < 4')
      end
    end }
    it { should parse('a,bc,d ').succeeding.like reference_parser }
    it { should parse('a,b,c,d').failing.like reference_parser }
    it { should parse('  ').failing.like reference_parser }
  end

  context 'with a nested apply rule' do
    let(:grammar) { define_grammar do
      rule(:foo) { semantic_assert :digit, '_.to_i > 200' }
      rule(:digit) { match /\d+/ }
    end }
    it { should parse('451a').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }
    it { should parse('123a').failing.like reference_parser }
  end

  context 'with a nested token rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        semantic_assert(token(/\w+/), '_.size > 5')
      end
    end }
    it { should parse('abc123').succeeding.like reference_parser }
    it { should parse('      ').failing.like reference_parser }
    it { should parse('abc12 ').failing.like reference_parser }
  end
end
