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
