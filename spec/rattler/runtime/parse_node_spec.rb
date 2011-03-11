require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rattler::Runtime::ParseNode do

  let(:children) { ['foo', 'bar'] }

  describe '#labeled' do

    context 'when the node has a :labeled attribute' do
      subject do
        Rattler::Runtime::ParseNode.parsed(children,
          :labeled => {:left => children.first, :right => children.last })
      end
      it 'returns the :labeled attribute' do
        subject.labeled.should == subject.attrs[:labeled]
      end
    end

    context 'when the node has no :labeled attribute' do
      subject do
        Rattler::Runtime::ParseNode.parsed(children)
      end
      it 'returns an empty hash' do
        subject.labeled.should == {}
      end
    end
  end

  describe '#[]' do

    context 'when the node has a :labeled attribute' do
      subject do
        Rattler::Runtime::ParseNode.parsed(children,
          :labeled => {:left => children.first, :right => children.last })
      end

      context 'given one of the labels' do
        it 'returns the child labeled by the symbol' do
          subject[:left].should == children.first
          subject[:right].should == children.last
        end
      end

      context 'given a symbol that is not one of the labels' do
        it 'returns nil' do
          subject[:foo].should be_nil
        end
      end
    end

    context 'when the node as no :labeled attribute' do
      subject do
        Rattler::Runtime::ParseNode.parsed(children)
      end

      it 'returns nil' do
        subject[:foo].should be_nil
      end
    end
  end

  describe '#method_missing' do
    subject do
      Rattler::Runtime::ParseNode.parsed(children,
        :labeled => {:left => children.first, :right => children.last })
    end

    it 'provides accessor methods for labeled children' do
      subject.left.should == children.first
      subject.right.should == children.last
    end
  end

end
