require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe OneOrMore do
  include CombinatorParserSpecHelper

  subject { OneOrMore[nested] }

  describe '#parse' do

    context 'with a capturing parser' do

      let(:nested) { Match[/\w/] }

      context 'while the parser matches' do
        it 'matches returning the results in an array' do
          parsing('foo').should result_in(['f', 'o', 'o']).at(3)
        end
      end

      context 'when the parser never matches' do
        it 'fails' do
          parsing('   ').should fail
        end
      end
    end

    context 'with a non-capturing parser' do

      let(:nested) { Skip[Match[/\w/]] }

      context 'while the parser matches' do
        it 'matches returning true' do
          parsing('foo').should result_in(true).at(3)
        end
      end

      context 'when the parser never matches' do
        it 'fails' do
          parsing('   ').should fail
        end
      end
    end

  end

  describe '#capturing?' do

    context 'with a capturing parser' do

      let(:nested) { Match[/\w/] }

      it 'is true' do
        subject.should be_capturing
      end
    end

    context 'with a non-capturing parser' do

      let(:nested) { Skip[Match[/\w/]] }

      it 'is false' do
        subject.should_not be_capturing
      end
    end

  end

  describe '#with_ws' do

    let(:ws) { Match[/\s*/] }
    let(:nested) { Match[/\w/] }

    it 'applies #with_ws to the nested parser' do
      subject.with_ws(ws).should == OneOrMore[Sequence[Skip[ws], nested]]
    end
  end

end
