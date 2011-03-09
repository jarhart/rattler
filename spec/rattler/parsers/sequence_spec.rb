require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Sequence do
  include CombinatorParserSpecHelper

  describe '#parse' do

    subject do
      Sequence[Match[/[[:alpha:]]+/], Match[/\=/], Match[/[[:digit:]]+/]]
    end

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
      subject do
        Sequence[Match[/[[:alpha:]]+/], Skip[Match[/\s+/]], Match[/[[:digit:]]+/]]
      end
      context 'when all of the parsers match in sequence' do
        it 'only includes results of its capturing parsers in the result array' do
          parsing('foo 42').should result_in ['foo', '42']
        end
      end
    end

    context 'with only one capturing parser' do
      subject do
        Sequence[Skip[Match[/\s+/]], Match[/\w+/]]
      end
      context 'when all of the parsers match in sequence' do
        it 'returns the result of the capturing parser' do
          parsing('  abc123').should result_in 'abc123'
        end
      end
    end

    context 'with no capturing parsers' do
      subject do
        Sequence[Skip[Match[/\s*/]], Skip[Match[/#[^\n]+/]]]
      end
      context 'when all of the parsers match in sequence' do
        it 'returns true' do
          parsing(' # foo').should result_in true
        end
      end
    end

    context 'with an apply parser referencing a non-capturing rule' do
      subject do
        Sequence[Match[/[[:alpha:]]+/], Apply[:ws], Match[/[[:digit:]]+/]]
      end

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
      subject do
        Sequence[Skip[Match[/\s*/]], Match[/\w+/]]
      end
      it 'is true' do
        subject.should be_capturing
      end
    end

    context 'with no capturing parsers' do
      subject do
        Sequence[Skip[Match[/\s*/]], Skip[Match[/#[^\n]+/]]]
      end
      it 'is false' do
        subject.should_not be_capturing
      end
    end
  end

end
