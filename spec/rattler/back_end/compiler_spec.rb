require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rattler::BackEnd::Compiler do
  include CompilerSpecHelper

  subject { described_class }

  describe '.compile_parser' do

    context 'given parse rules' do

      let(:rules) { define_parser do
        rule(:word) { match /\w+/ }
        rule(:space) { match /\s*/ }
      end }

      let(:parser_base) { Rattler::Runtime::RecursiveDescentParser }

      let(:result) { described_class.compile_parser(parser_base, rules) }

      it 'compiles a match_xxx method for each rule' do
        result.should have_method(:match_word)
        result.should have_method(:match_space)
      end
    end

    ########## match ##########
    context 'given a match rule' do
      let(:rules) { define_parser do
        rule(:digit) { match /\d/ }
      end }
      it { should compile(rules).test_parsing('451').twice }
      it { should compile(rules).test_parsing ' 4' }
      it { should compile(rules).test_parsing 'foo' }
    end

    ########## choice ##########
    context 'given a choice rule' do
      let(:rules) { define_parser do
        rule :atom do
          match(/[[:alpha:]]+/) & match(/[[:digit:]]+/)
        end
      end }

      it { should compile(rules).test_parsing('abc123').twice }
      it { should compile(rules).test_parsing '==' }

      context 'with nested choices' do
        let(:rules) { define_parser do
          rule(:foo) do
              (match('a') | match('b')) \
            | (match('c') | match('d'))
          end
        end }
        it { should compile(rules).test_parsing('abcd').repeating(4).times }
        it { should compile(rules).test_parsing '123' }
      end

      context 'with nested sequences' do
        let(:rules) { define_parser do
          rule(:foo) do
              match('a') & match('b') \
            | match('c') & match('d')
          end
        end }
        it { should compile(rules).test_parsing('abcd').twice }
        it { should compile(rules).test_parsing '123' }
      end

      context 'with nested optional parsers' do
        let(:rules) { define_parser do
          rule(:foo) do
            optional('a') | optional('b')
          end
        end }
        it { should compile(rules).test_parsing('abcd').repeating(3).times }
        it { should compile(rules).test_parsing '123' }
      end
    end

    ########## sequence ##########
    context 'given a sequence rule' do
      let(:rules) { define_parser do
        rule :assignment do
          match(/[[:alpha:]]+/) & match('=') & match(/[[:digit:]]+/)
        end
      end }

      it { should compile(rules).test_parsing 'val=42  ' }
      it { should compile(rules).test_parsing 'val=x' }

      context 'with non-capturing parsers' do
        it { should compile { rule :foo do
                match(/[[:alpha:]]+/) & skip(/\s+/) & match(/[[:digit:]]+/)
              end }.
            test_parsing 'foo 42' }
      end

      context 'with only one capturing parser' do
        it { should compile { rule :foo do
                skip(/\s+/) & match(/\w+/)
              end }.
            test_parsing '  abc123' }
      end

      context 'with no capturing parsers' do
        it { should compile { rule :foo do
                skip(/\s*/) & skip(/#[^\n]+/)
              end }.
            test_parsing ' # foo' }
      end

      context 'with an apply referencing a non-capturing rule' do
        it { should compile {
              rule :ws do
                skip(/\s+/)
              end
              rule :foo do
                match(/[[:alpha:]]+/) & match(:ws) & match(/[[:digit:]]+/)
              end }.
            test_parsing('foo 42').as :foo }
      end
    end

    ########## optional ##########
    context 'given an optional rule' do
      let(:rules) { define_parser do
        rule :foo do
          optional(/\w+/)
        end
      end }
      it { should compile(rules).test_parsing 'foo ' }
      it { should compile(rules).test_parsing '    ' }

      context 'with a non-capturing parser' do
        let(:rules) { define_parser do
          rule :foo do
            optional(skip(/\w+/))
          end
        end }
        it { should compile(rules).test_parsing 'foo ' }
        it { should compile(rules).test_parsing '    ' }
      end
    end

    ########## zero-or-more ##########
    context 'given a zero-or-more rule' do
      let(:rules) { define_parser do
        rule :foo do
          zero_or_more(/\w+/)
        end
      end }
      it { should compile(rules).test_parsing 'foo ' }
      it { should compile(rules).test_parsing '    ' }

      context 'with a non-capturing parser' do
        let(:rules) { define_parser do
          rule :foo do
            zero_or_more(skip(/\w+/))
          end
        end }
        it { should compile(rules).test_parsing 'foo ' }
        it { should compile(rules).test_parsing '    ' }
      end
    end

    ########## one-or-more ##########
    context 'given a one-or-more rule' do
      let(:rules) { define_parser do
        rule :foo do
          one_or_more(/\w+/)
        end
      end }
      it { should compile(rules).test_parsing 'foo ' }
      it { should compile(rules).test_parsing '    ' }

      context 'with a non-capturing parser' do
        let(:rules) { define_parser do
          rule :foo do
            one_or_more(skip(/\w+/))
          end
        end }
        it { should compile(rules).test_parsing 'foo ' }
        it { should compile(rules).test_parsing '    ' }
      end
    end

    ########## list ##########
    context 'given a list rule' do
      let(:rules) { define_parser do
        rule :foo do
          list(/\w+/, /[,;]/)
        end
      end }
      it { should compile(rules).test_parsing '  ' }
      it { should compile(rules).test_parsing 'foo  ' }
      it { should compile(rules).test_parsing 'foo,bar;baz  ' }
      it { should compile(rules).test_parsing 'foo,bar,  ' }

      context 'with a non-capturing parser' do
        let(:rules) { define_parser do
          rule :foo do
            list(skip(/\w+/), /[,;]/)
          end
        end }
        it { should compile(rules).test_parsing '  ' }
        it { should compile(rules).test_parsing 'foo  ' }
        it { should compile(rules).test_parsing 'foo,bar;baz  ' }
        it { should compile(rules).test_parsing 'foo,bar,  ' }
      end
    end

    ########## list1 ##########
    context 'given a list1 rule' do
      let(:rules) { define_parser do
        rule :foo do
          list1(/\w+/, /[,;]/)
        end
      end }
      it { should compile(rules).test_parsing '  ' }
      it { should compile(rules).test_parsing 'foo  ' }
      it { should compile(rules).test_parsing 'foo,bar;baz  ' }
      it { should compile(rules).test_parsing 'foo,bar,  ' }

      context 'with a non-capturing parser' do
        let(:rules) { define_parser do
          rule :foo do
            list(skip(/\w+/), /[,;]/)
          end
        end }
        it { should compile(rules).test_parsing '  ' }
        it { should compile(rules).test_parsing 'foo  ' }
        it { should compile(rules).test_parsing 'foo,bar;baz  ' }
        it { should compile(rules).test_parsing 'foo,bar,  ' }
      end
    end

    ########## apply ##########
    context 'given an apply rule' do
      let(:rules) { define_parser do
        rule(:digit) { match /\d/ }
        rule(:foo) { match :digit }
      end }
      it { should compile(rules).test_parsing('451 ').twice.as :foo }
      it { should compile(rules).test_parsing 'hi' }
    end

    ########## assert ##########
    context 'given an assert rule' do

      context 'with a nested match rule' do
        let(:rules) { define_parser do
          rule(:word) { assert /\w+/ }
        end }
        it { should compile(rules).test_parsing 'abc123  ' }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested choice rule' do
        let(:rules) { define_parser do
          rule(:word) { assert(match(/[[:alpha:]]+/) | match(/[[:digit:]]+/)) }
        end }
        it { should compile(rules).test_parsing('abc123  ').twice }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested sequence rule' do
        let(:rules) { define_parser do
          rule(:word) { assert(match(/[[:alpha:]]+/) & match(/[[:digit:]]+/)) }
        end }
        it { should compile(rules).test_parsing 'abc123  ' }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested optional rule' do
        let(:rules) { define_parser do
          rule(:word) { assert(optional(/\w+/)) }
        end }
        it { should compile(rules).test_parsing 'abc123  ' }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested zero_or_more rule' do
        let(:rules) { define_parser do
          rule(:word) { assert(zero_or_more(/\w/)) }
        end }
        it { should compile(rules).test_parsing 'abc123  ' }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested one_or_more rule' do
        let(:rules) { define_parser do
          rule(:word) { assert(one_or_more(/\w/)) }
        end }
        it { should compile(rules).test_parsing 'abc123  ' }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested list rule' do
        let(:rules) { define_parser do
          rule(:word) { assert(list(/\w+/, /,/)) }
        end }
        it { should compile(rules).test_parsing 'abc,123  ' }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested list1 rule' do
        let(:rules) { define_parser do
          rule(:word) { assert(list(/\w+/, /,/)) }
        end }
        it { should compile(rules).test_parsing 'abc,123  ' }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested apply rule' do
        let(:rules) { define_parser do
          rule(:word) { assert /\w+/ }
          rule(:foo) { match :word }
        end }
        it { should compile(rules).test_parsing('abc123  ').as :foo }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested dispatch-action rule' do
        let(:rules) { define_parser do
          rule(:word) { assert(dispatch_action(/\w+/)) }
        end }
        it { should compile(rules).test_parsing 'abc123  ' }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested token rule' do
        let(:rules) { define_parser do
          rule(:word) { assert(token(match(/\w+/))) }
        end }
        it { should compile(rules).test_parsing 'abc123  ' }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested skip rule' do
        let(:rules) { define_parser do
          rule(:word) { assert(skip(/\w+/)) }
        end }
        it { should compile(rules).test_parsing 'abc123  ' }
        it { should compile(rules).test_parsing '   ' }
      end
    end

    ########## disallow ##########
    context 'given a disallow rule' do

      context 'with a nested match rule' do
        let(:rules) { define_parser do
          rule(:word) { disallow /\w+/ }
        end }
        it { should compile(rules).test_parsing '   ' }
        it { should compile(rules).test_parsing 'abc123  ' }
      end

      context 'with a nested choice rule' do
        let(:rules) { define_parser do
          rule(:word) { disallow(match(/[[:alpha:]]/) | match(/[[:digit:]]/)) }
        end }
        it { should compile(rules).test_parsing('abc123  ').twice }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested sequence rule' do
        let(:rules) { define_parser do
          rule(:word) { disallow(match(/[[:alpha:]]/) & match(/[[:digit:]]/)) }
        end }
        it { should compile(rules).test_parsing 'abc123  ' }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested optional rule' do
        let(:rules) { define_parser do
          rule(:word) { disallow(optional(/\w+/)) }
        end }
        it { should compile(rules).test_parsing 'abc123  ' }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested zero_or_more rule' do
        let(:rules) { define_parser do
          rule(:word) { disallow(zero_or_more(/\w/)) }
        end }
        it { should compile(rules).test_parsing 'abc123  ' }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested one_or_more rule' do
        let(:rules) { define_parser do
          rule(:word) { disallow(one_or_more(/\w/)) }
        end }
        it { should compile(rules).test_parsing 'abc123  ' }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested apply rule' do
        let(:rules) { define_parser do
          rule(:word) { disallow /\w+/ }
          rule(:foo) { match :word }
        end }
        it { should compile(rules).test_parsing '   ' }
        it { should compile(rules).test_parsing('abc123  ').as :foo }
      end

      context 'with a nested token rule' do
        let(:rules) { define_parser do
          rule(:word) { disallow(token(match(/\w+/))) }
        end }
        it { should compile(rules).test_parsing 'abc123  ' }
        it { should compile(rules).test_parsing '   ' }
      end

      context 'with a nested skip rule' do
        let(:rules) { define_parser do
          rule(:word) { disallow(skip(/\w+/)) }
        end }
        it { should compile(rules).test_parsing 'abc123  ' }
        it { should compile(rules).test_parsing '   ' }
      end
    end

    ########## dispatch_action ##########
    context 'given a dispatch-action rule' do

      context 'with a nested match rule' do
        let(:rules) { define_parser do
          rule(:digits) { dispatch_action(/\d+/) }
        end }
        it { should compile(rules).test_parsing '451a' }
        it { should compile(rules).test_parsing '    ' }
      end

      context 'with a nested choice rule' do
        let(:rules) { define_parser do
          rule :atom do
            dispatch_action(match(/[[:alpha:]]+/) | match(/[[:digit:]]+/))
          end
        end }

        it { should compile(rules).test_parsing '451a' }
        it { should compile(rules).test_parsing '    ' }

        context 'with labels' do
          let(:rules) { define_parser do
            rule :assignment do
              dispatch_action(
                label(:word, /[[:alpha:]]+/) |
                label(:num,  /[[:digit:]]+/)
              )
            end
          end }
          it { should compile(rules).test_parsing 'foo ' }
          it { should compile(rules).test_parsing '42 ' }
        end
      end

      context 'with a nested sequence rule' do
        let(:rules) { define_parser do
          rule :assignment do
            dispatch_action(
              match(/[[:alpha:]]+/) &
              match('=') &
              match(/[[:digit:]]+/)
            )
          end
        end }

        it { should compile(rules).test_parsing 'val=42 ' }
        it { should compile(rules).test_parsing 'val=x' }

        context 'with labels' do
          let(:rules) { define_parser do
            rule :assignment do
              dispatch_action(
                label(:name, /[[:alpha:]]+/) &
                match('=') &
                label(:value, /[[:digit:]]+/)
              )
            end
          end }
          it { should compile(rules).test_parsing 'val=42 ' }
        end
      end

      context 'with a nested optional rule' do
        let(:rules) { define_parser do
          rule :foo do
            dispatch_action(optional(/\w+/))
          end
        end }
        it { should compile(rules).test_parsing 'foo ' }
        it { should compile(rules).test_parsing '    ' }
      end

      context 'with a nested zero-or-more rule' do
        let(:rules) { define_parser do
          rule :foo do
            dispatch_action(zero_or_more(/\w/))
          end
        end }
        it { should compile(rules).test_parsing 'foo ' }
        it { should compile(rules).test_parsing '    ' }
      end

      context 'with a nested one-or-more rule' do
        let(:rules) { define_parser do
          rule :foo do
            dispatch_action(one_or_more(/\w/))
          end
        end }
        it { should compile(rules).test_parsing 'foo ' }
        it { should compile(rules).test_parsing '    ' }
      end

      context 'with a nested apply rule' do
        let(:rules) { define_parser do
          rule(:digit) { match /\d/ }
          rule(:foo) { dispatch_action :digit }
        end }
        it { should compile(rules).test_parsing('451a').twice.as :foo }
        it { should compile(rules).test_parsing('    ').as :foo }
      end

      context 'with a nested token rule' do
        let(:rules) { define_parser do
          rule :foo do
            dispatch_action(token(match(/\w+/)))
          end
        end }
        it { should compile(rules).test_parsing 'abc123' }
        it { should compile(rules).test_parsing '    ' }
      end

      context 'with a nested skip rule' do
        let(:rules) { define_parser do
          rule :foo do
            dispatch_action(skip(/\w+/))
          end
        end }
        it { should compile(rules).test_parsing 'abc123' }
        it { should compile(rules).test_parsing '    ' }
      end
    end

    ########## direct_action ##########
    context 'given a direct-action rule' do

      context 'with a nested match rule' do
        let(:rules) { define_parser do
          rule(:num) { direct_action(/\d+/, '|_| _.to_i') }
        end }
        it { should compile(rules).test_parsing '451a' }
        it { should compile(rules).test_parsing '    ' }
      end

      context 'with a nested choice rule' do
        let(:rules) { define_parser do
          rule :foo do
            direct_action(
              match(/[[:alpha:]]+/) | match(/[[:digit:]]+/),
              '|_| _.size'
            )
          end
        end }

        it { should compile(rules).test_parsing 'abc123' }
        it { should compile(rules).test_parsing '451a' }
        it { should compile(rules).test_parsing '    ' }
      end

      context 'with a nested sequence rule' do
        let(:rules) { define_parser do
          rule :assignment do
            direct_action(
              match(/[[:alpha:]]+/) & match('=') & match(/[[:digit:]]+/),
              '|l,_,r| "#{r} -> #{l}"'
            )
          end
        end }

        it { should compile(rules).test_parsing 'val=42 ' }
        it { should compile(rules).test_parsing 'val=x' }

        context 'with labels' do
          let(:rules) { define_parser do
            rule :assignment do
              direct_action(
                label(:name, /[[:alpha:]]+/) & match('=') & label(:value, /[[:digit:]]+/),
                '"#{value} -> #{name}"'
              )
            end
          end }
          it { should compile(rules).test_parsing 'val=42 ' }
        end
      end

      context 'with a nested optional rule' do
        let(:rules) { define_parser do
          rule :foo do
            direct_action(optional(/\w+/), '|_| _.size')
          end
        end }
        it { should compile(rules).test_parsing 'foo ' }
        it { should compile(rules).test_parsing '    ' }
      end

      context 'with a nested zero-or-more rule' do
        let(:rules) { define_parser do
          rule :foo do
            direct_action(zero_or_more(/\w/), '|_| _.size')
          end
        end }
        it { should compile(rules).test_parsing 'foo ' }
        it { should compile(rules).test_parsing '    ' }
      end

      context 'with a nested one-or-more rule' do
        let(:rules) { define_parser do
          rule :foo do
            direct_action(one_or_more(/\w/), '|_| _.size')
          end
        end }
        it { should compile(rules).test_parsing 'foo ' }
        it { should compile(rules).test_parsing '    ' }
      end

      context 'with a nested apply rule' do
        let(:rules) { define_parser do
          rule(:digit) { match /\d/ }
          rule(:foo) { direct_action :digit, '|_| _.to_i' }
        end }
        it { should compile(rules).test_parsing('451a').twice.as :foo }
        it { should compile(rules).test_parsing('    ').as :foo }
      end

      context 'with a nested token rule' do
        let(:rules) { define_parser do
          rule :foo do
            direct_action(token(/\w+/), '|_| _.size')
          end
        end }
        it { should compile(rules).test_parsing 'abc123' }
        it { should compile(rules).test_parsing '    ' }
      end

      context 'with a nested skip rule' do
        let(:rules) { define_parser do
          rule :foo do
            direct_action(skip(/\w+/), '42' )
          end
        end }
        it { should compile(rules).test_parsing 'abc123' }
        it { should compile(rules).test_parsing '    ' }
      end
    end

    ########## token ##########
    context 'given a token rule' do

      context 'with a nested match rule' do
        let(:rules) { define_parser do
          rule(:digits) { token(match(/\d+/)) }
        end }
        it { should compile(rules).test_parsing '451a' }
        it { should compile(rules).test_parsing 'hi' }
      end

      context 'with a nested choice rule' do
        let(:rules) { define_parser do
          rule(:atom) do
            token(match(/[[:alpha:]]+/) | match(/[[:digit:]]+/))
          end
        end }

        it { should compile(rules).test_parsing 'abc123 ' }
        it { should compile(rules).test_parsing '==' }

        context 'with non-capturing choices' do
          let(:rules) { define_parser do
            rule(:atom) do
              token(skip(/[[:alpha:]]+/) | match(/[[:digit:]]+/))
            end
          end }
          it { should compile(rules).test_parsing 'abc123 ' }
          it { should compile(rules).test_parsing '==' }
        end
      end

      context 'with a nested sequence rule' do
        let(:rules) { define_parser do
          rule(:atom) do
            token(match(/[[:alpha:]]+/) & match(/[[:digit:]]+/))
          end
        end }

        it { should compile(rules).test_parsing 'foo42!' }
        it { should compile(rules).test_parsing 'val=x' }

        context 'with non-capturing parsers' do
          let(:rules) { define_parser do
            rule :foo do
              token(match(/[[:alpha:]]+/) & skip(/\s+/) & match(/[[:digit:]]+/))
            end
          end }
          it { should compile(rules).test_parsing 'foo 42' }
          it { should compile(rules).test_parsing 'foo bar' }
        end
      end

      context 'with a nested optional rule' do
        let(:rules) { define_parser do
          rule :foo do
            token(optional(/\w+/))
          end
        end }

        it { should compile(rules).test_parsing 'foo ' }
        it { should compile(rules).test_parsing '    ' }

        context 'with a non-capturing rule' do
          let(:rules) { define_parser do
            rule :foo do
              token(optional(skip(/\w+/)))
            end
          end }
          it { should compile(rules).test_parsing 'foo ' }
          it { should compile(rules).test_parsing '    ' }
        end
      end

      context 'with a nested zero-or-more rule' do
        let(:rules) { define_parser do
          rule :foo do
            token(zero_or_more(/\w/))
          end
        end }

        it { should compile(rules).test_parsing 'foo ' }
        it { should compile(rules).test_parsing '    ' }

        context 'with a non-capturing rule' do
          let(:rules) { define_parser do
            rule :foo do
              token(zero_or_more(skip(/\w/)))
            end
          end }
          it { should compile(rules).test_parsing 'foo ' }
          it { should compile(rules).test_parsing '    ' }
        end
      end

      context 'with a nested one-or-more rule' do
        let(:rules) { define_parser do
          rule :foo do
            token(one_or_more(/\w/))
          end
        end }

        it { should compile(rules).test_parsing 'foo ' }
        it { should compile(rules).test_parsing '    ' }

        context 'with a non-capturing rule' do
          let(:rules) { define_parser do
            rule :foo do
              token(one_or_more(skip(/\w/)))
            end
          end }
          it { should compile(rules).test_parsing 'foo ' }
          it { should compile(rules).test_parsing '    ' }
        end
      end

      context 'with a nested apply rule' do
        let(:rules) { define_parser do
          rule(:digits) { match(/\d+/) }
          rule(:foo) { token(match(:digits)) }
        end }

        it { should compile(rules).test_parsing('451a').as :foo }
        it { should compile(rules).test_parsing 'hi' }

        context 'applying a non-capturing rule' do
          let(:rules) { define_parser do
            rule(:digits) { skip(/\d+/) }
            rule(:foo) { token(match(:digits)) }
          end }
          it { should compile(rules).test_parsing('451a').as :foo }
          it { should compile(rules).test_parsing 'hi' }
        end
      end

      context 'with a nested dispatch-action rule' do
        let(:rules) { define_parser do
          rule(:foo) { token(dispatch_action(/\w+/)) }
        end }
        it { should compile(rules).test_parsing 'abc123' }
        it { should compile(rules).test_parsing '  ' }
      end

      context 'with a nested skip rule' do
        let(:rules) { define_parser do
          rule(:foo) { token(skip(/\w+/)) }
        end }
        it { should compile(rules).test_parsing 'abc123' }
        it { should compile(rules).test_parsing '  ' }
      end
    end

    ########## skip ##########
    context 'given a skip rule' do

      context 'with a nested match rule' do
        let(:rules) { define_parser do
          rule(:ws) { skip(/\s+/) }
        end }
        it { should compile(rules).test_parsing '   foo' }
        it { should compile(rules).test_parsing 'hi' }
      end

      context 'with a nested choice rule' do
        let(:rules) { define_parser do
          rule(:ws) do
            skip(match(/\s+/) | match(/\#[^\n]*/))
          end
        end }
        it { should compile(rules).test_parsing('   # hi there ').twice }
        it { should compile(rules).test_parsing 'hi' }
      end

      context 'with a nested sequence rule' do
        let(:rules) { define_parser do
          rule :foo do
            skip(match(/[[:alpha:]]+/) & match(/[[:digit:]]+/))
          end
        end }
        it { should compile(rules).test_parsing 'foo42!' }
        it { should compile(rules).test_parsing 'val=x' }
      end

      context 'with a nested optional rule' do
        let(:rules) { define_parser do
          rule :foo do
            skip(optional(/\w+/))
          end
        end }
        it { should compile(rules).test_parsing 'foo ' }
        it { should compile(rules).test_parsing '    ' }
      end

      context 'with a nested zero-or-more rule' do
        let(:rules) { define_parser do
          rule :foo do
            skip(zero_or_more(/\w/))
          end
        end }
        it { should compile(rules).test_parsing 'foo ' }
        it { should compile(rules).test_parsing '    ' }
      end

      context 'with a nested one-or-more rule' do
        let(:rules) { define_parser do
          rule :foo do
            skip(one_or_more(/\w/))
          end
        end }
        it { should compile(rules).test_parsing 'foo ' }
        it { should compile(rules).test_parsing '    ' }
      end

      context 'with a nested apply rule' do
        let(:rules) { define_parser do
          rule(:digits) { match(/\d+/) }
          rule(:foo) { skip(:digits) }
        end }
        it { should compile(rules).test_parsing('451a').as :foo }
        it { should compile(rules).test_parsing('hi').as :foo }
      end
    end

  end

  def have_method(rule_name)
    be_method_defined(rule_name)
  end

end
