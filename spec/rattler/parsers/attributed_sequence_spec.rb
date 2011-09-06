require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe AttributedSequence do
  include CombinatorParserSpecHelper

  include Rattler::Runtime

  subject { AttributedSequence[*children] }

  describe '#parse' do

    context 'with a single capture and a semantic action' do

      context 'when the action uses a parameter' do

        let(:children) { [Match[/\w+/], SemanticAction['|s| "<#{s}>"']] }

        it 'binds the capture to the parameter and returns the result' do
          parsing('foo').should result_in '<foo>'
        end
      end

      context 'when the action uses "_"' do

        let(:children) { [Match[/\w+/], SemanticAction['"<#{_}>"']] }

        it 'binds the capture to "_" and returns the result' do
          parsing('foo').should result_in '<foo>'
        end
      end
    end

    context 'with a single capture and a node action' do

      let(:children) { [Match[/\w+/], NodeAction[ParseNode.name]] }

      it 'returns a new node with the capture' do
        parsing('foo').should result_in ParseNode.parsed(['foo'])
      end
    end

    context 'with multiple captures and a semantic action' do

      context 'when the action uses parameters' do

        let :children do
          [Match[/[a-z]+/], Match[/\d+/], SemanticAction['|a,b| b+a']]
        end

        it 'binds the captures to the parameters and returns the result' do
          parsing('abc123').should result_in '123abc'
        end
      end

      context 'when the action uses "_"' do

        let(:children) { [Match[/[a-z]+/], Match[/\d+/], SemanticAction['_']] }

        it 'binds the array of captures to "_" and returns the result' do
          parsing('abc123').should result_in ['abc', '123']
        end
      end
    end

    context 'with multiple captures and a node action' do

      let(:children) { [Match[/[a-z]+/], Match[/\d+/], NodeAction[ParseNode.name]] }

      it 'returns a new node with the captures' do
        parsing('abc123').should result_in ParseNode.parsed(['abc', '123'])
      end
    end

    context 'with a single labeled capture and a semantic action' do

      let(:children) { [Label[:a, Match[/\w+/]], SemanticAction['"<#{a}>"']] }

      it 'binds the capture to the label name and returns the result' do
        parsing('foo').should result_in '<foo>'
      end
    end

    context 'with multiple labeled captures and a semantic action' do

      let(:children) { [
        Label[:a, Match[/[[:alpha:]]+/]],
        Label[:b, Match[/[[:digit:]]+/]],
        SemanticAction['b + a']
      ] }

      it 'binds the captures to the label names and returns the result' do
        parsing('abc123').should result_in '123abc'
      end
    end

    context 'with labeled captures and a node action' do

      let(:children) { [
        Label[:a, Match[/[[:alpha:]]+/]],
        Label[:b, Match[/[[:digit:]]+/]],
        NodeAction[ParseNode.name]
      ] }

      it 'returns a new node with the captures and :labeled attribute' do
        parsing('abc123').should result_in(
          ParseNode.parsed(['abc', '123'], :labeled => {:a => 'abc', :b => '123'})
        )
      end
    end
  end

  describe '#capturing?' do

    context 'when attributed with a semantic action' do

      let(:children) { [Match[/\w+/], SemanticAction['_']] }

      it 'is true' do
        subject.should be_capturing
      end
    end

    context 'when attributed with a semantic predicate' do

      let(:children) { [Match[/\w+/], Assert[SemanticAction['_ == "hi"']]] }

      it 'is false' do
        subject.should_not be_capturing
      end
    end

    context 'when attributed with a side effect' do

      let(:children) { [Match[/\w+/], Skip[SemanticAction['@word = _']]] }

      it 'is false' do
        subject.should_not be_capturing
      end
    end

    context 'when attributed with a node action' do

      let(:children) { [Match[/\w+/], NodeAction[ParseNode]] }

      it 'is true' do
        subject.should be_capturing
      end
    end
  end

  describe '#with_ws' do

    let(:ws) { Match[/\s*/] }
    let(:children) { [Match[/\w+/], SemanticAction['_']] }

    it 'applies #with_ws to the children parsers' do
      subject.with_ws(ws).should ==
        AttributedSequence[Sequence[Skip[ws], children[0]], children[1]]
    end
  end

  describe '#capture_count' do

    context 'with a single capture and a semantic action' do

      let(:children) { [Match[/\w+/], SemanticAction['_']] }

      it 'is 1' do
        subject.capture_count.should == 1
      end
    end

    context 'with two captures and a semantic predicate' do

      let(:children) do
        [Match[/\w+/], Skip[Match[/\s+/]], Match[/\w+/], SemanticAction['_']]
      end

      it 'is 2' do
        subject.capture_count.should == 2
      end
    end
  end

  describe '#&' do

    let(:children) { [Match[/\w+/], SemanticAction['_']] }

    it 'returns a new sequence with the given parser' do
      (subject & Match[/:/]).should == Sequence[subject, Match[/:/]]
    end
  end

  describe '#>>' do

    let(:children) { [Match[/\w+/], SemanticAction['_']] }

    it 'returns a new attributed sequence with the given semantic action' do
      (subject >> SemanticAction['_ * 2']).should ==
        AttributedSequence[subject, SemanticAction['_ * 2']]
    end
  end

end
