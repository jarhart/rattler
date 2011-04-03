require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Assert do
  include CombinatorParserSpecHelper

  subject { Assert[nested] }

  let(:nested) { Match[/\w+/] }

  describe '#parse' do

    context 'when the parser matches' do
      it 'returns true without advancing' do
        parsing('abc123  ').should result_in(true).at(0)
      end
    end

    context 'when the parser fails' do
      it 'fails' do
        parsing('   ').should fail
      end
    end

  end

  describe '#capturing?' do
    it 'is false' do
      subject.should_not be_capturing
    end
  end

  describe '#with_ws' do

    let(:ws) { Match[/\s*/] }

    it 'applies #with_ws to the nested parser' do
      subject.with_ws(ws).should == Assert[Sequence[Skip[ws], nested]]
    end
  end

end
