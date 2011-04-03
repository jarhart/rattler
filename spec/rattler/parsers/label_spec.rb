require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Label do
  include CombinatorParserSpecHelper

  subject { Label[:name, nested] }

  let(:nested) { Match[/\w+/] }

  describe '#parse' do

    it 'matches identically to its parser' do
      parsing('abc123  ').should result_in('abc123').at(6)
      parsing('==').should fail
    end

    context 'on success' do
      it 'adds a mapping from its label to its result' do
        parsing('foo  ').should result_in('foo').with_scope(:name => 'foo')
      end
    end
  end

  describe '#capturing?' do

    context 'with a capturing parser' do
      it 'is true' do
        subject.should be_capturing
      end
    end

    context 'with a non-capturing parser' do

      let(:nested) { Skip[Match[/\s+/]] }

      it 'is false' do
        subject.should_not be_capturing
      end
    end

  end

  describe '#with_ws' do

    let(:ws) { Match[/\s*/] }

    it 'applies #with_ws to the nested parser' do
      subject.with_ws(ws).should == Label[:name, Sequence[Skip[ws], nested]]
    end
  end

end
