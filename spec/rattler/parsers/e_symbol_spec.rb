require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ESymbol do
  include CombinatorParserSpecHelper

  subject { ESymbol[] }

  describe '#parse' do
    it 'returns true without advancing' do
      parsing('anything').at(4).should result_in(true).at(4)
      parsing('        ').at(7).should result_in(true).at(7)
    end
  end

  describe '#capturing?' do
    it 'is false' do
      subject.should_not be_capturing
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
