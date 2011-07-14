require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe SemanticDisallow do
  include CombinatorParserSpecHelper

  subject { SemanticDisallow[nested, code] }

  describe '#parse' do

    context 'with a capturing parser' do

      let(:nested) { Match[/[[:digit:]]+/] }
      let(:code) { '|s| s == "451"' }

      context 'when the parser matches' do

        context 'if the semantic action results in a true value' do
          it 'fails' do
            parsing('451a').should fail
          end
        end

        context 'if the semantic action results in a false value' do
          it 'succeeds' do
            parsing('321a').should result_in('321').at(3)
          end
        end
      end

      context 'when the parser fails' do
        it 'fails' do
          parsing('foo').should fail
        end
      end

      context 'using the "_" character' do

        let(:code) { '_ == "451"' }

        it 'evaluates the predicate binding the captured result as "_"' do
          parsing('451a').should fail
          parsing('321a').should result_in('321').at(3)
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
        should == SemanticDisallow[Sequence[Skip[ws], nested], code]
    end
  end

end
