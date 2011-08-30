require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe SemanticAction do
  include CombinatorParserSpecHelper

  describe '#parse' do

    let(:scope) { ParserScope.new(bindings, captures) }

    let(:bindings) { {} }
    let(:captures) { [] }

    context 'when the expression has no parameters' do

      subject { SemanticAction['42'] }

      it 'returns the evaluation of the expression without advancing' do
        parsing('anything').at(4).should result_in(42).at(4)
      end
    end

    context 'when the expression has parameters' do

      subject { SemanticAction['|a,b| a * b'] }
      let(:captures) { [2, 3] }

      it 'returns the evaluation of the expression using captures' do
        parsing('anything').at(4).should result_in(6).at(4)
      end
    end

    context 'when the expression uses "_"' do

      context 'given a single capture' do

        subject { SemanticAction['_ * 4'] }
        let(:captures) { [3] }

        it 'returns the evaluation of the expression using the capture' do
          parsing('anything').at(4).should result_in(12).at(4)
        end
      end

      context 'given multiple captures' do

        subject { SemanticAction['_ * 2'] }
        let(:captures) { [3, 2] }

        it 'returns the evaluation of the expression using the array of captures' do
          parsing('anything').at(4).should result_in([3, 2, 3, 2]).at(4)
        end
      end
    end

    context 'when the expression uses labels' do

      subject { SemanticAction['x * y'] }
      let(:bindings) { {:x => 3, :y => 5 } }

      it 'returns the evaluation of the expression using bindings' do
        parsing('anything').at(4).should result_in(15).at(4)
      end
    end
  end

  describe '#capturing?' do
    it 'is true' do
      SemanticAction['@foo'].should be_capturing
    end
  end

  describe '#with_ws' do

    subject { SemanticAction['@foo'] }

    let(:ws) { Match[/\s*/] }

    it 'returns the action unchanged' do
      subject.with_ws(ws).should == subject
    end
  end

end
