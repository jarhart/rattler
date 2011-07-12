require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path('assert_compiler_examples', File.dirname(__FILE__))
require File.expand_path('disallow_compiler_examples', File.dirname(__FILE__))
require File.expand_path('dispatch_action_compiler_examples', File.dirname(__FILE__))
require File.expand_path('direct_action_compiler_examples', File.dirname(__FILE__))
require File.expand_path('side_effect_compiler_examples', File.dirname(__FILE__))
require File.expand_path('semantic_assert_compiler_examples', File.dirname(__FILE__))
require File.expand_path('semantic_disallow_compiler_examples', File.dirname(__FILE__))
require File.expand_path('token_compiler_examples', File.dirname(__FILE__))
require File.expand_path('skip_compiler_examples', File.dirname(__FILE__))

shared_examples_for 'a compiled parser' do
  include CompilerSpecHelper

  it_behaves_like 'a compiled parser with an assert'
  it_behaves_like 'a compiled parser with a disallow'
  it_behaves_like 'a compiled parser with a dispatch action'
  it_behaves_like 'a compiled parser with a direct action'
  it_behaves_like 'a compiled parser with a side effect'
  it_behaves_like 'a compiled parser with a positive semantic predicate'
  it_behaves_like 'a compiled parser with a negative semantic predicate'
  it_behaves_like 'a compiled parser with a token'
  it_behaves_like 'a compiled parser with a skip'

  subject { compiled_parser }

  let(:reference_parser) { combinator_parser grammar }

  ########## match ##########
  context 'with a match rule' do
    let(:grammar) { define_grammar do
      rule(:digit) { match /\d/ }
    end }
    it { should parse('451').succeeding.twice.like reference_parser }
    it { should parse(' 4').failing.like reference_parser }
    it { should parse('foo').failing.like reference_parser }
  end

  ########## choice ##########
  context 'with a choice rule' do
    let(:grammar) { define_grammar do
      rule(:atom) { match(/[[:alpha:]]+/) | match(/[[:digit:]]+/) }
    end }
    it { should parse('abc123').succeeding.twice.like reference_parser }
    it { should parse('==').failing.like reference_parser }

    context 'with non-capturing parsers' do
      let(:grammar) { define_grammar do
        rule :foo do
          skip(/\s+/) | skip(/\{[^\}]*\}/)
        end
      end }
      it { should parse('   foo').succeeding.like reference_parser }
      it { should parse('{foo}').succeeding.like reference_parser }
    end

    context 'with nested choices' do
      let(:grammar) { define_grammar do
        rule(:foo) do
          ( (match('a') | match('b')) \
          | (match('c') | match('d')) )
        end
      end }
      it { should parse('abcd').succeeding(4).times.like reference_parser }
      it { should parse('123').failing.like reference_parser }
    end

    context 'with nested sequences' do
      let(:grammar) { define_grammar do
        rule(:foo) do
          ( match('a') & match('b') \
          | match('c') & match('d') )
        end
      end }
      it { should parse('abcd').succeeding.twice.like reference_parser }
      it { should parse('123').failing.like reference_parser }
    end

    context 'with nested optional parsers' do
      let(:grammar) { define_grammar do
        rule(:foo) do
          optional('a') | optional('b')
        end
      end }
      it { should parse('abcd').succeeding(3).times.like reference_parser }
      it { should parse('123').succeeding.like reference_parser }
    end
  end

  ########## sequence ##########
  context 'with a sequence rule' do
    let(:grammar) { define_grammar do
      rule :assignment do
        match(/[[:alpha:]]+/) & match('=') & match(/[[:digit:]]+/)
      end
    end }
    it { should parse('val=42 ').succeeding.like reference_parser }
    it { should parse('val=x ').failing.like reference_parser }

    context 'with non-capturing parsers' do
      let(:grammar) { define_grammar do
        rule :foo do
          match(/[[:alpha:]]+/) & skip(/\s+/) & match(/[[:digit:]]+/)
        end
      end }
      it { should parse('foo 42').succeeding.like reference_parser }
    end

    context 'with only one capturing parser' do
      let(:grammar) { define_grammar do
        rule :foo do
          skip(/\s+/) & match(/\w+/)
        end
      end }
      it { should parse('  abc123').succeeding.like reference_parser }
    end

    context 'with no capturing parsers' do
      let(:grammar) { define_grammar do
        rule :foo do
          skip(/\s*/) & skip(/#[^\n]+/)
        end
      end }
      it { should parse(' # foo').succeeding.like reference_parser }
    end

    context 'with an apply referencing a non-capturing rule' do
      let(:grammar) { define_grammar do
        rule :foo do
          match(/[[:alpha:]]+/) & match(:ws) & match(/[[:digit:]]+/)
        end
        rule :ws do
          skip(/\s+/)
        end
      end }
      it { should parse('foo 42').succeeding.like reference_parser }
    end
  end

  ########## optional ##########
  context 'with an optional rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        optional(/\w+/)
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }

    context 'with a non-capturing parser' do
      let(:grammar) { define_grammar do
        rule :foo do
          optional(skip(/\w+/))
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end
  end

  ########## zero-or-more ##########
  context 'with an zero-or-more rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        zero_or_more(/\w/)
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').succeeding.like reference_parser }

    context 'with a non-capturing parser' do
      let(:grammar) { define_grammar do
        rule :foo do
          zero_or_more(skip(/\w/))
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end
  end

  ########## one-or-more ##########
  context 'with an one-or-more rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        one_or_more(/\w/)
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('    ').failing.like reference_parser }

    context 'with a non-capturing parser' do
      let(:grammar) { define_grammar do
        rule :foo do
          one_or_more(skip(/\w/))
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end
  end

  ########## repeat ##########
  context 'with a repeat rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        repeat(/\w/, 2, 4)
      end
    end }
    it { should parse('foo ').succeeding.like reference_parser }
    it { should parse('abcde ').succeeding.like reference_parser }
    it { should parse('a ').failing.like reference_parser }

    context 'with no upper bound' do
      let(:grammar) { define_grammar do
        rule :foo do
          repeat(/\w/, 2, nil)
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('abcde ').succeeding.like reference_parser }
      it { should parse('a ').failing.like reference_parser }
    end

    context 'with a non-capturing parser' do
      let(:grammar) { define_grammar do
        rule :foo do
          repeat(skip(/\w/), 2, 4)
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('abcde ').succeeding.like reference_parser }
      it { should parse('a ').failing.like reference_parser }
    end
  end

  ########## list ##########
  context 'given a list rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        list(/\w+/, /[,;]/, 2, nil)
      end
    end }
    it { should parse('foo  ').failing.like reference_parser }
    it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
    it { should parse('foo,bar,  ').succeeding.like reference_parser }

    context 'with an upper bound' do
      let(:grammar) { define_grammar do
        rule :foo do
          list(/\w+/, /[,;]/, 2, 4)
        end
      end }
      it { should parse('foo  ').failing.like reference_parser }
      it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
      it { should parse('a,b,c,d,e  ').succeeding.like reference_parser }
      it { should parse('foo,bar,  ').succeeding.like reference_parser }
    end

    context 'with a non-capturing parser' do
      let(:grammar) { define_grammar do
        rule :foo do
          list(skip(/\w+/), /[,;]/, 2, nil)
        end
      end }
      it { should parse('foo  ').failing.like reference_parser }
      it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
      it { should parse('foo,bar,  ').succeeding.like reference_parser }

      context 'with an upper bound' do
        let(:grammar) { define_grammar do
          rule :foo do
            list(skip(/\w+/), /[,;]/, 2, 4)
          end
        end }
        it { should parse('foo  ').failing.like reference_parser }
        it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
        it { should parse('a,b,c,d,e  ').succeeding.like reference_parser }
        it { should parse('foo,bar,  ').succeeding.like reference_parser }
      end

      context 'with "zero-or-more" bounds' do
        let(:grammar) { define_grammar do
          rule :foo do
            list(skip(/\w+/), /[,;]/, 0, nil)
          end
        end }
        it { should parse('  ').succeeding.like reference_parser }
        it { should parse('foo  ').succeeding.like reference_parser }
        it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
      end

      context 'with "one-or-more" bounds' do
        let(:grammar) { define_grammar do
          rule :foo do
            list(skip(/\w+/), /[,;]/, 1, nil)
          end
        end }
        it { should parse('  ').failing.like reference_parser }
        it { should parse('foo  ').succeeding.like reference_parser }
        it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
      end
    end
  end

  ########## apply ##########
  context 'given an apply rule' do
    let(:grammar) { define_grammar do
      rule(:digit) { match /\d/ }
      rule(:foo) { match :digit }
    end }
    it { should parse('451 ').twice.succeeding.like reference_parser }
    it { should parse('hi').failing.like reference_parser }
  end

  ########## eof ##########
  context 'given eof' do
    let(:grammar) { define_grammar do
      rule(:foo) { eof }
    end }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').from(3).succeeding.like reference_parser }
    it { should parse('foo').failing.like reference_parser }
  end

  ########## E ##########
  context 'given "E" symbol' do
    let(:grammar) { define_grammar do
      rule(:foo) { e }
    end }
    it { should parse('').succeeding.like reference_parser }
    it { should parse('foo').succeeding.like reference_parser }
  end
end
