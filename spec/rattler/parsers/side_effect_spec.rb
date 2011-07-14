require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe SideEffect do
  include CombinatorParserSpecHelper

  subject { SideEffect[nested, code] }

  describe '#parse' do

    context 'with a capturing parser' do

      let(:nested) { Match[/[[:digit:]]+/] }
      let(:code) { '|s| $__side_effect_result__ = s * 2' }

      context 'when the parser matches' do
        it 'applies the action binding the captured results as arguments' do
          parsing('451a').should result_in('451').at(3)
          $__side_effect_result__.should == '451451'
        end
      end

      context 'when the parser fails' do
        it 'fails' do
          parsing('foo').should fail
        end
      end

      context 'using the "_" character' do

        let(:code) { '$__side_effect_result__ = _ * 2' }

        it 'applies the action binding the captured result as "_"' do
          parsing('321a').should result_in('321').at(3)
          $__side_effect_result__.should == '321321'
        end
      end
    end
  end

  describe '#capturing?' do

    let(:code) { '' }

    context 'with a capturing parser' do

      let(:nested) { Match[/\w+/] }

      it 'is true' do
        subject.should be_capturing
      end
    end

    context 'with a non-capturing parser' do

      let(:nested) { Skip[Match[/\s*/]] }

      it 'is false' do
        subject.should_not be_capturing
      end
    end
  end

  describe '#with_ws' do

    let(:ws) { Match[/\s*/] }
    let(:nested) { Match[/\w+/] }
    let(:code) { '' }

    it 'applies #with_ws to the nested parser' do
      subject.with_ws(ws).
        should == SideEffect[Sequence[Skip[ws], nested], code]
    end
  end

end
