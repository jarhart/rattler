require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include Rattler::Parsers

describe ParserDSL do

  subject { ParserDSL.new }

  describe '#match' do
    context 'given a regexp' do
      it 'creates a regexp match parser' do
        subject.match(/\w+/).should == Match[/\w+/]
      end
    end
    context 'given a string' do
      it 'creates a literal match parser' do
        subject.match('.').should == Match[/\./]
      end
    end
    context 'given a posix name' do
      it 'creates a posix class match parser' do
        subject.match(:ALNUM).should == Match[/[[:alnum:]]/]
        subject.match(:DIGIT).should == Match[/[[:digit:]]/]
      end
    end
    context 'given a symbol' do
      it 'creates an apply parser' do
        subject.match(:expr).should == Apply[:expr]
      end
    end
    context 'given :EOF' do
      it 'creates the eof parser' do
        subject.match(:EOF).should == Eof[]
      end
    end
    context 'given :E' do
      it 'creates the "E" symbol parser' do
        subject.match(:E).should == ESymbol[]
      end
    end
  end

  describe '#optional' do
    context 'given a parser' do
      it 'creates a repeat parser with optional bounds' do
        subject.optional(subject.match(/\w+/)).
          should == Repeat[Match[/\w+/], 0, 1]
      end
    end
    context 'given a match argument' do
      it 'creates a repeat parser with optional bounds' do
        subject.optional(/\w+/).should == Repeat[Match[/\w+/], 0, 1]
      end
    end
  end

  describe '#zero_or_more' do
    context 'given a parser' do
      it 'creates a repeat parser with zero-or-more bounds' do
        subject.zero_or_more(subject.match(/\w+/)).
          should == Repeat[Match[/\w+/], 0, nil]
      end
    end
    context 'given a match argument' do
      it 'creates a repeat parser with zero-or-more bounds' do
        subject.zero_or_more(/\w+/).should == Repeat[Match[/\w+/], 0, nil]
      end
    end
  end

  describe '#one_or_more' do
    context 'given a parser' do
      it 'creates a repeat parser with one-or-more bounds' do
        subject.one_or_more(subject.match(/\w+/)).
          should == Repeat[Match[/\w+/], 1, nil]
      end
    end
    context 'given a match argument' do
      it 'creates a repeat parser with one-or-more bounds' do
        subject.one_or_more(/\w+/).should == Repeat[Match[/\w+/], 1, nil]
      end
    end
  end

  describe '#repeat' do
    context 'given parsers' do
      it 'creates a repeat parser' do
        subject.repeat(subject.match(/\w+/), 2, 4).
          should == Repeat[Match[/\w+/], 2, 4]
      end
    end
    context 'given match arguments' do
      it 'creates a repeat parser' do
        subject.repeat(/\w+/, 2, 4).should == Repeat[Match[/\w+/], 2, 4]
      end
    end
  end

  describe '#list' do
    context 'given parsers' do
      it 'creates a list parser' do
        subject.list(subject.match(/\w+/), subject.match(/,/), 2, 4).
        should == ListParser[Match[/\w+/], Match[/,/], 2, 4]
      end
    end
    context 'given match arguments' do
      it 'creates a list parser' do
        subject.list(/\w+/, ',', 2, 4).
        should == ListParser[Match[/\w+/], Match[/,/], 2, 4]
      end
    end
  end

  describe '#assert' do
    context 'given a parser' do
      it 'create an assert parser' do
        subject.assert(subject.match(/\w+/)).should == Assert[Match[/\w+/]]
      end
    end
    context 'given a match argument' do
      it 'create an assert match parser' do
        subject.assert(/\w+/).should == Assert[Match[/\w+/]]
      end
    end
  end

  describe '#disallow' do
    context 'given a parser' do
      it 'creates a disallow parser' do
        subject.disallow(subject.match(/\w+/)).should == Disallow[Match[/\w+/]]
      end
    end
    context 'given a match argument' do
      it 'creates a disallow match parser' do
        subject.disallow(/\w+/).should == Disallow[Match[/\w+/]]
      end
    end
  end

  describe '#eof' do
    it 'creates the eof parser' do
      subject.eof.should == Eof[]
    end
  end

  describe '#e' do
    it 'creates the "E" symbol parser' do
      subject.e.should == ESymbol[]
    end
  end

  describe '#dispatch_action' do
    context 'given a parser' do
      context 'given options' do
        it 'creates an dispatch-action parser with the options' do
          subject.dispatch_action(subject.match(/\w+/), :method => 'word').
          should == DispatchAction[Match[/\w+/], {:method => 'word'}]
        end
      end
      context 'given no options' do
        it 'creates a default dispatch-action parser' do
          subject.dispatch_action(subject.match(/\w+/)).should == DispatchAction[Match[/\w+/]]
        end
      end
    end
    context 'given a match argument' do
      context 'given options' do
        it 'creates an dispatch-action match parser with the options' do
          subject.dispatch_action(/\w+/, :method => 'word').
          should == DispatchAction[Match[/\w+/], {:method => 'word'}]
        end
      end
      context 'given no options' do
        it 'creates a default dispatch-action match parser' do
          subject.dispatch_action(/\w+/).should == DispatchAction[Match[/\w+/]]
        end
      end
    end
  end

  describe '#direct_action' do
    context 'given a parser' do
      it 'creates a direct-action parser' do
        subject.direct_action(subject.match(/\d+/), '|_| _.to_i').
        should == DirectAction[Match[/\d+/], '|_| _.to_i']
      end
    end
    context 'given a match argument' do
      it 'creates a direct-action match parser' do
        subject.direct_action(/\d+/, '|_| _.to_i').
        should == DirectAction[Match[/\d+/], '|_| _.to_i']
      end
    end
  end

  describe '#semantic_action' do
    it 'creates a semantic action' do
      subject.semantic_action('_.to_i').
      should == SemanticAction['_.to_i']
    end
  end

  describe '#token' do
    context 'given a parser' do
      it 'creates a token parser' do
        subject.token(subject.match(/\w+/)).should == Token[Match[/\w+/]]
      end
    end
    context 'given a match argument' do
      it 'create a token match parser' do
        subject.token(/\w+/).should == Token[Match[/\w+/]]
      end
    end
    context 'given a block' do
      it 'creates token rules' do
        subject.token(:word) { match(/\w+/) }.
        should == Rule[:word, Token[Match[/\w+/]]]
      end
    end
  end

  describe '#skip' do
    context 'given a parser' do
      it 'creates a skip parser' do
        subject.skip(subject.match(/\w+/)).should == Skip[Match[/\w+/]]
      end
    end
    context 'given a match argument' do
      it 'creates a skip match parser' do
        subject.skip(/\w+/).should == Skip[Match[/\w+/]]
      end
    end
  end

  describe '#label' do
    context 'given a parser' do
      it 'creates a label parser' do
        subject.label(:word, subject.match(/\w+/)).should == Label[:word, Match[/\w+/]]
      end
    end
    context 'given a match argument' do
      it 'create a label match parser' do
        subject.label(:word, /\w+/).should == Label[:word, Match[/\w+/]]
      end
    end
  end

  describe '#fail' do
    it 'creates a fail-expr parser' do
      subject.fail('var expected').should == Fail[:expr, 'var expected']
    end
  end

  describe '#fail_rule' do
    it 'creates a fail-rule parser' do
      subject.fail_rule('var expected').should == Fail[:rule, 'var expected']
    end
  end

  describe '#fail_parse' do
    it 'creates a fail-parse parser' do
      subject.fail_parse('var expected').should == Fail[:parse, 'var expected']
    end
  end

  describe '#rule' do
    context 'given a block' do
      it 'creates a rule' do
        subject.rule(:word) { skip(/\s*/) & match(/\w+/) }.
        should == Rule[:word, Sequence[Skip[Match[/\s*/]], Match[/\w+/]]]
      end
      context 'with whitespace defined' do
        it 'creates rules that skip the whitespace' do
          subject.with_ws(/\s*/) { rule(:word) { match(/\w+/) } }.
          should == Rule[:word, Sequence[Skip[Match[/\s*/]], Match[/\w+/]]]
        end
      end
    end
  end

  describe '#rules' do
    context 'given a block' do
      it 'creates multiple rules' do
        subject.rules do
          rule(:word) { match(/\w+/) }
          rule(:number) { match(/\d+/) }
        end.
        should == RuleSet[
          Rule[:word, Match[/\w+/]],
          Rule[:number, Match[/\d+/]]
        ]
      end
    end
  end

end
