require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include Rattler::Runtime

describe NodeAction do
  include CombinatorParserSpecHelper

  describe '#parse' do

    subject { NodeAction['Rattler::Runtime::ParseNode'] }

    let(:scope) { ParserScope.new(bindings, captures) }

    let(:bindings) { {} }
    let(:captures) { [] }

    context 'with no bindings or captures' do
      it 'returns an empty node without advancing' do
        parsing('anything').at(4).should result_in(ParseNode.parsed([])).at(4)
      end
    end

    context 'with a single capture' do

      let(:captures) { ['foo'] }

      it 'returns a node with the capture' do
        parsing('anything').should result_in ParseNode.parsed(['foo'])
      end
    end

    context 'with multiple captures' do

      let(:captures) { ['foo', 'bar'] }

      it 'returns a node with the captures' do
        parsing('anything').should result_in ParseNode.parsed(['foo', 'bar'])
      end
    end

    context 'with bindings' do

      let(:bindings) { {:a => 'foo', :b => 'bar'} }

      it 'returns a node with the bindings as the :labeled attribute' do
        parsing('anything').should result_in(
          ParseNode.parsed([], :labeled => {:a => 'foo', :b => 'bar'})
        )
      end
    end

    context 'when the action has node attributes' do

      subject { NodeAction['Rattler::Runtime::ParseNode',
                            {:node_attrs => {:name => "FOO"}}] }

      it 'returns a node with the attributes' do
        parsing('anything').should result_in(
          ParseNode.parsed([], :name => "FOO")
        )
      end
    end
  end

  describe '#capturing?' do
    it 'is true' do
      NodeAction['Expr'].should be_capturing
    end
  end

  describe '#capturing_decidable?' do
    it 'is true' do
      NodeAction['Expr'].should be_capturing_decidable
    end
  end

  describe '#with_ws' do

    subject { NodeAction['Expr'] }

    let(:ws) { Match[/\s*/] }

    it 'returns the action unchanged' do
      subject.with_ws(ws).should == subject
    end
  end

  describe '.parsed' do

    subject { NodeAction.parsed(results, {}) }

    context 'given all empty parse results' do

      let(:results) { [[], []] }

      it 'creates a NodeAction with the default node_type of ParseNode' do
        subject.should == NodeAction['Rattler::Runtime::ParseNode']
      end
    end

    context 'given a node_type result' do

      let(:results) { [[['Expr', []]], []]}

      it 'creates a NodeAction with the node_type' do
        subject.should == NodeAction['Expr']
      end
    end

    context 'given a name result' do

      let(:results) { [[], ['"FOO"']] }

      it 'creates a NodeAction with node_attrs for the name' do
        subject.should == NodeAction['Rattler::Runtime::ParseNode',
                                      {:node_attrs => {:name => 'FOO'}}]
      end
    end
  end

end
