require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Sequence do
  include CombinatorParserSpecHelper

  subject { Sequence[*nested] }

  describe '#parse' do

    let(:nested) { [Match[/[[:alpha:]]+/], Match[/\=/], Match[/[[:digit:]]+/]] }

    context 'when all of the parsers match in sequence' do
      it 'matches returning the results in an array' do
        parsing('val=42').should result_in(['val', '=', '42']).at(6)
      end
    end

    context 'when one of the parsers fails' do
      it 'fails and backtracks' do
        parsing('val=x').should fail
      end
    end

    context 'with non-capturing parsers' do

      let :nested do
        [Match[/[[:alpha:]]+/], Skip[Match[/\s+/]], Match[/[[:digit:]]+/]]
      end

      context 'when all of the parsers match in sequence' do
        it 'only includes results of its capturing parsers in the result array' do
          parsing('foo 42').should result_in ['foo', '42']
        end
      end
    end

    context 'with only one capturing parser' do

      let(:nested) { [Skip[Match[/\s+/]], Match[/\w+/]] }

      context 'when all of the parsers match in sequence' do
        it 'returns the result of the capturing parser' do
          parsing('  abc123').should result_in 'abc123'
        end
      end
    end

    context 'with no capturing parsers' do

      let(:nested) { [Skip[Match[/\s*/]], Skip[Match[/#[^\n]+/]]] }

      context 'when all of the parsers match in sequence' do
        it 'returns true' do
          parsing(' # foo').should result_in true
        end
      end
    end

    context 'with an apply parser referencing a non-capturing rule' do

      let(:nested) { [Match[/[[:alpha:]]+/], Apply[:ws], Match[/[[:digit:]]+/]] }

      let(:rules) { RuleSet[Rule[:ws, Skip[Match[/\s+/]]]] }

      context 'when all of the parsers match in sequence' do
        it 'only includes results of its capturing parsers in the result array' do
          parsing('foo 42').should result_in ['foo', '42']
        end
      end
    end

    context 'with a single capture and a semantic action' do

      context 'when the action uses a parameter' do

        let(:nested) { [Match[/\w+/], SemanticAction['|s| "<#{s}>"']] }

        it 'binds the capture to the parameter' do
          parsing('foo').should result_in ['foo', '<foo>']
        end
      end

      context 'when the action uses "_"' do

        let(:nested) { [Match[/\w+/], SemanticAction['"<#{_}>"']] }

        it 'binds the capture to "_"' do
          parsing('foo').should result_in ['foo', '<foo>']
        end
      end
    end

    context 'with multiple captures and a semantic action' do

      context 'when the action uses parameters' do

        let(:nested) { [Match[/[a-z]+/], Match[/\d+/], SemanticAction['|a,b| b+a']] }

        it 'binds the captures to the parameters' do
          parsing('abc123').should result_in ['abc', '123', '123abc']
        end
      end

      context 'when the action uses "_"' do

        let(:nested) { [Match[/[a-z]+/], Match[/\d+/], SemanticAction['_']] }

        it 'binds the array of captures to "_"' do
          parsing('abc123').should result_in ['abc', '123', ['abc', '123']]
        end
      end
    end

    context 'with a single labeled capture and a semantic action' do

      let(:nested) { [Label[:a, Match[/\w+/]], SemanticAction['"<#{a}>"']] }

      it 'binds the capture to the label name' do
        parsing('foo').should result_in ['foo', '<foo>']
      end
    end

    context 'with multiple labeled captures and a semantic action' do

      let(:nested) { [
        Label[:a, Match[/[[:alpha:]]+/]],
        Label[:b, Match[/[[:digit:]]+/]],
        SemanticAction['b + a']
      ] }

      it 'binds the captures to the label names' do
        parsing('abc123').should result_in ['abc', '123', '123abc']
      end
    end
  end

  describe '#capturing?' do

    context 'with any capturing parsers' do

      let(:nested) { [Skip[Match[/\s*/]], Match[/\w+/]] }

      it 'is true' do
        subject.should be_capturing
      end
    end

    context 'with no capturing parsers' do

      let(:nested) { [Skip[Match[/\s*/]], Skip[Match[/#[^\n]+/]]] }

      it 'is false' do
        subject.should_not be_capturing
      end
    end
  end

  describe '#with_ws' do

    let(:ws) { Match[/\s*/] }
    let(:nested) { [Match[/[[:alpha:]]+/], Match[/[[:digit:]]+/]] }

    it 'applies #with_ws to the nested parsers' do
      subject.with_ws(ws).should == Sequence[
        Sequence[Skip[ws], nested[0]],
        Sequence[Skip[ws], nested[1]]
      ]
    end
  end

end
