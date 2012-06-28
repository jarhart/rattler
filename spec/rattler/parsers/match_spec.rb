require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rattler::Parsers::Match do
  include CombinatorParserSpecHelper

  subject { Match[/\w+/] }

  describe '#parse' do

    context 'when the regexp matches' do
      it 'succeeds returning the matched string' do
        parsing('abc123  ').should result_in('abc123').at(6)
      end
    end

    context 'when the regexp does not match' do
      it 'fails' do
        parsing('  abc').should fail
        parsing('==').should fail
      end
    end

  end

  describe '#capturing?' do
    it 'is true' do
      subject.should be_capturing
    end
  end

  describe '#capturing_decidable?' do
    it 'is true' do
      subject.should be_capturing_decidable
    end
  end

  describe '#with_ws' do

    let(:ws) { Match[/\s*/] }

    it 'returns a parser that skips whitespace before matching' do
      subject.with_ws(ws).should == Sequence[Skip[ws], subject]
    end
  end

end
