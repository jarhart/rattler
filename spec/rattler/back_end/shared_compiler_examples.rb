shared_examples_for 'a compiled parser' do
  include CompilerSpecHelper

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

    context 'with optional bounds' do
      let(:grammar) { define_grammar do
        rule :foo do
          repeat(/\w+/, 0, 1)
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end

    context 'with zero-or-more bounds' do
      let(:grammar) { define_grammar do
        rule :foo do
          repeat(/\w/, 0, nil)
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').succeeding.like reference_parser }
    end

    context 'with one-or-more bounds' do
      let(:grammar) { define_grammar do
        rule :foo do
          repeat(/\w/, 1, nil)
        end
      end }
      it { should parse('foo ').succeeding.like reference_parser }
      it { should parse('    ').failing.like reference_parser }
    end
  end

  ########## list ##########
  context 'given a list rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        list(/\w+/, /[,;]/)
      end
    end }
    it { should parse('  ').succeeding.like reference_parser }
    it { should parse('foo  ').succeeding.like reference_parser }
    it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
    it { should parse('foo,bar,  ').succeeding.like reference_parser }

    context 'with a non-capturing parser' do
      let(:grammar) { define_grammar do
        rule :foo do
          list(skip(/\w+/), /[,;]/)
        end
      end }
      it { should parse('  ').succeeding.like reference_parser }
      it { should parse('foo  ').succeeding.like reference_parser }
      it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
      it { should parse('foo,bar,  ').succeeding.like reference_parser }
    end
  end

  ########## list1 ##########
  context 'given a list1 rule' do
    let(:grammar) { define_grammar do
      rule :foo do
        list1(/\w+/, /[,;]/)
      end
    end }
    it { should parse('  ').failing.like reference_parser }
    it { should parse('foo  ').succeeding.like reference_parser }
    it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
    it { should parse('foo,bar,  ').succeeding.like reference_parser }

    context 'with a non-capturing parser' do
      let(:grammar) { define_grammar do
        rule :foo do
          list1(skip(/\w+/), /[,;]/)
        end
      end }
      it { should parse('  ').failing.like reference_parser }
      it { should parse('foo  ').succeeding.like reference_parser }
      it { should parse('foo,bar;baz  ').succeeding.like reference_parser }
      it { should parse('foo,bar,  ').succeeding.like reference_parser }
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

  ########## assert ##########
  context 'given an assert rule' do

    context 'with a nested match rule' do
      let(:grammar) { define_grammar do
        rule(:word) { assert /\w+/ }
      end }
      it { should parse('abc123  ').succeeding.like reference_parser }
      it { should parse('   ').failing.like reference_parser }
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

    context 'with a nested zero_or_more rule' do
      let(:grammar) { define_grammar do
        rule(:word) { assert(zero_or_more(/\w/)) }
      end }
      it { should parse('abc123  ').succeeding.like reference_parser }
      it { should parse('   ').succeeding.like reference_parser }
    end

    context 'with a nested one_or_more rule' do
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
        rule(:word) { assert(list(/\w+/, /,/)) }
      end }
      it { should parse('abc,123 ').succeeding.like reference_parser }
      it { should parse('   ').succeeding.like reference_parser }
    end

    context 'with a nested list1 rule' do
      let(:grammar) { define_grammar do
        rule(:word) { assert(list1(/\w+/, /,/)) }
      end }
      it { should parse('abc,123 ').succeeding.like reference_parser }
      it { should parse('   ').failing.like reference_parser }
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

  ########## disallow ##########
  context 'given a disallow rule' do

    context 'with a nested match rule' do
      let(:grammar) { define_grammar do
        rule(:word) { disallow /\w+/ }
      end }
      it { should parse('   ').succeeding.like reference_parser }
      it { should parse('abc123  ').failing.like reference_parser }
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
        rule(:word) { disallow(list(/\w+/, /,/)) }
      end }
      it { should parse('   ').failing.like reference_parser }
      it { should parse('abc,123 ').failing.like reference_parser }
    end

    context 'with a nested list1 rule' do
      let(:grammar) { define_grammar do
        rule(:word) { disallow(list1(/\w+/, /,/)) }
      end }
      it { should parse('   ').succeeding.like reference_parser }
      it { should parse('abc,123 ').failing.like reference_parser }
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

  ########## dispatch_action ##########
  context 'given a dispatch-action rule' do

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
          dispatch_action(list1(/\w+/, /,/))
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

  ########## direct_action ##########
  context 'given a direct-action rule' do

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
          direct_action(list1(/\w+/, /,/), '|_| _.reduce(:+)')
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

  ########## token ##########
  context 'given a token rule' do

    context 'with a nested match rule' do
      let(:grammar) { define_grammar do
        rule(:digits) { token(match(/\d+/)) }
      end }
      it { should parse('451a').succeeding.like reference_parser }
      it { should parse('hi').failing.like reference_parser }
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

  ########## skip ##########
  context 'given a skip rule' do

    context 'with a nested match rule' do
      let(:grammar) { define_grammar do
        rule(:ws) { skip(/\s+/) }
      end }
      it { should parse('   foo').succeeding.like reference_parser }
      it { should parse('hi').failing.like reference_parser }
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

end
