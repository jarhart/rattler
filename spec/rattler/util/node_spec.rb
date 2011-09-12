require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'pp'

include Rattler::Util

describe Node do

  describe '#children' do

    context 'when the Node has children' do
      subject do
        Node.new(Node.new(:name => 'foo'), Node.new(:name => 'bar'))
      end

      it 'returns the children' do
        subject.children.
          should == [Node.new(:name => 'foo'), Node.new(:name => 'bar')]
      end
    end

    context 'when the Node has no children' do

      subject { Node.new }

      it 'returns an empty array' do
        subject.children.should == []
      end
    end

    context 'when the Node has children and attributes' do
      subject do
        Node.new(Node.new(:name => 'foo'), Node.new(:name => 'bar'), :foo => 'bar')
      end

      it 'returns the children' do
        subject.children.
          should == [Node.new(:name => 'foo'), Node.new(:name => 'bar')]
      end
    end

    context 'when the Node has only attributes' do

      subject { Node.new(:foo => 'bar', :bar => nil) }

      it 'returns an empty array' do
        subject.children.should == []
      end
    end
  end

  describe '#attrs' do
    context 'when the Node has attributes' do

      subject { Node.new(:foo => 'bar', :bar => nil) }

      it 'returns a Hash of the attributes' do
        subject.attrs.should == { :foo => 'bar', :bar => nil }
      end
    end

    context 'when the Node has no attributes' do

      subject { Node.new }

      it 'returns an empty Hash' do
        subject.attrs.should == {}
      end
    end

    context 'when the Node has children and attributes' do
      subject do
        Node.new(Node.new(:name => 'foo'), :foo => 'bar', :bar => nil)
      end

      it 'returns a Hash of the attributes' do
        subject.attrs.should == { :foo => 'bar', :bar => nil }
      end
    end

    context 'when the Node has only children' do
      subject do
        Node.new(Node.new(:name => 'foo'), Node.new(:name => 'bar'))
      end

      it 'returns an empty Hash' do
        subject.attrs.should == {}
      end
    end
  end

  describe '#child' do
    context 'when the Node has children' do
      subject do
        Node.new(Node.new(:name => 'foo'), Node.new(:name => 'bar'))
      end

      it 'returns the first child' do
        subject.child.should == Node.new(:name => 'foo')
      end

      context 'given an index' do
        it 'returns the child at the index' do
          subject.child(0).should == Node.new(:name => 'foo')
          subject.child(1).should == Node.new(:name => 'bar')
        end
      end
    end

    context 'when the Node has no children' do

      subject { Node.new }

      it 'returns nil' do
        subject.child.should be_nil
      end
    end
  end

  describe '#name' do
    context 'when the Node as a name attribute' do

      subject { Node.new(:name => 'foo' ) }

      it 'uses the name attribute as name' do
        subject.name.should == 'foo'
      end
    end

    context 'when the Node has no name attribute' do

      subject { Node.new }

      it 'uses the class name as name' do
        subject.name.should == 'Rattler::Util::Node'
      end
    end
  end

  describe '#[]' do
    context 'when the Node has children' do
      subject do
        Node.new(Node.new(:name => 'foo'), Node.new(:name => 'bar'))
      end

      context 'given a single index' do
        it 'returns the child at the index' do
          subject[0].should == Node.new(:name => 'foo')
          subject[1].should == Node.new(:name => 'bar')
        end
      end

      context 'given a negative index' do
        it 'counts backward from the last child' do
          subject[-1].should == Node.new(:name => 'bar')
          subject[-2].should == Node.new(:name => 'foo')
        end
      end

      context 'given an out-of-range index' do
        it 'returns nil' do
          subject[3].should be_nil
        end
      end

      context 'given an index and a length' do
        it 'returns an array of children starting at the index' do
          subject[0, 2].should == [Node.new(:name => 'foo'), Node.new(:name => 'bar')]
          subject[0, 1].should == [Node.new(:name => 'foo')]
          subject[1, 1].should == [Node.new(:name => 'bar')]
        end
      end

      context 'given a negative index and a length' do
        it 'counts backward from the last child' do
          subject[-2, 2].should == [Node.new(:name => 'foo'), Node.new(:name => 'bar')]
          subject[-2, 1].should == [Node.new(:name => 'foo')]
          subject[-1, 1].should == [Node.new(:name => 'bar')]
        end
      end

      context 'given an out-of-range index and a length' do
        it 'returns nil' do
          subject[3].should be_nil
        end
      end

      context 'given an index exactly one past the last child and a length' do
        it 'returns an empty array' do
          subject[2, 2].should == []
        end
      end

      context 'given a range' do
        it 'return an array of children indexed by the range' do
          subject[0..1].should == [Node.new(:name => 'foo'), Node.new(:name => 'bar')]
          subject[0..0].should == [Node.new(:name => 'foo')]
          subject[1..1].should == [Node.new(:name => 'bar')]
        end
      end

      context 'given a range with a negative index' do
        it 'counts backward from the last child' do
          subject[-2..-1].should == [Node.new(:name => 'foo'), Node.new(:name => 'bar')]
          subject[-2..-2].should == [Node.new(:name => 'foo')]
          subject[-1..-1].should == [Node.new(:name => 'bar')]
        end
      end

      context 'given a range with an out-of-range index' do
        it 'returns nil' do
          subject[3..3].should be_nil
        end
      end

      context 'given a range starting exactly one past the last child' do
        it 'returns an empty array' do
          subject[2..2].should == []
        end
      end
    end
  end

  describe '#count' do
    context 'when the Node has children' do
      subject do
        Node.new(Node.new(:name => 'foo'), Node.new(:name => 'bar'))
      end

      it 'returns the number of children' do
        subject.count.should == 2
      end
    end

    context 'when the Node has no children' do
      subject { Node.new }

      it 'returns 0' do
        subject.count.should == 0
      end
    end
  end

  describe '#==' do
    subject { Node.new(Node.new(:name => 'foo'), :foo => 'bar') }

    context 'given a node with the same children and attributes' do
      it 'returns true' do
        subject.should == Node.new(Node.new(:name => 'foo'), :foo => 'bar')
      end
    end

    context 'given a node with different children' do
      it 'returns false' do
        subject.should_not == Node.new(Node.new(:name => 'boo'), :foo => 'bar')
      end
    end

    context 'given a node with extra children' do
      it 'returns false' do
        subject.should_not ==
          Node.new(Node.new(:name => 'boo'), Node.new, :foo => 'bar')
      end
    end

    context 'given a node with no children' do
      it 'returns false' do
        subject.should_not == Node.new(:foo => 'bar')
      end
    end

    context 'given a node with the same children and different attributes' do
      it 'returns false' do
        subject.should_not == Node.new(Node.new(:name => 'foo'), :foo => 'baz')
      end
    end

    context 'given a node with the same children and extra attributes' do
      it 'returns false' do
        subject.should_not ==
          Node.new(Node.new(:name => 'foo'), :foo => 'bar', :bar => 'baz')
      end
    end

    context 'given a node with the same children but no attributes' do
      it 'returns false' do
        subject.should_not == Node.new(Node.new(:name => 'foo'))
      end
    end
  end

  describe '#each' do

    subject { Node.new(Node.new(:name => 'foo'), Node.new(:name => 'bar')) }

    let(:expected_items) do
      [Node.new(:name => 'foo'), Node.new(:name => 'bar')]
    end

    it 'iterates over #children' do
      subject.each {|_| _.should == expected_items.shift }
    end
  end

  describe '#with_children' do

    subject { Node.new(Node.new(:name => 'foo'), Node.new(:name => 'bar')) }

    let :new_children do
      [Node.new(:name => 'boo'), Node.new(:name => 'baz')]
    end

    it 'returns a new node with the children replaced' do
      subject.with_children(new_children).should ==
        Node.new(Node.new(:name => 'boo'), Node.new(:name => 'baz'))
    end
  end

  describe '#method_missing' do

    subject { Node.new(:foo => 'bar', :bar => nil) }

    it 'provides accessor methods for attributes' do
      subject.foo.should == 'bar'
      subject.bar.should == nil
    end
  end

  describe '#respond_to?' do

    subject { Node.new(:foo => 'bar', :bar => nil) }

    context 'given an attribute name' do
      it 'returns true' do
        subject.should respond_to(:foo)
        subject.should respond_to(:bar)
      end
    end

    context 'given a meaningless name' do
      it 'returns false' do
        subject.should_not respond_to(:fred)
      end
    end
  end

  describe '#pretty_print' do

    context 'for an empty node' do

      subject { Node.new }

      it 'prints the class name + "[]"' do
        subject.pretty_inspect.should == "Rattler::Util::Node[]\n"
      end
    end

    context 'for a node with a name' do

      subject { Node.new(:name => 'foo') }

      it 'prints the name in angle brackets after the class name' do
        subject.pretty_inspect.should == "Rattler::Util::Node<\"foo\">[]\n"
      end
    end

    context 'for a node with attributes' do

      subject { Node.new(:a => 'foo', :b => 'bar') }

      it 'prints the attributes in square brackets' do
        subject.pretty_inspect.should ==
        "Rattler::Util::Node[:a=>\"foo\", :b=>\"bar\"]\n"
      end
    end

    context 'for a node with a name and attributes' do

      subject { Node.new(:name => 'foo', :foo => 'bar') }

      it 'omits the name from the square brackets' do
        subject.pretty_inspect.should ==
          "Rattler::Util::Node<\"foo\">[:foo=>\"bar\"]\n"
      end
    end

    context 'for a node with children' do

      subject { Node.new('foo', 'bar') }

      it 'prints the children in square brackets' do
        subject.pretty_inspect.should ==
          "Rattler::Util::Node[\"foo\", \"bar\"]\n"
      end
    end

    context 'for a node with children and attributes' do

      subject { Node.new('aa', 'bb', :foo => 'bar') }

      it 'prints the children then the attributes in square brackets' do
        subject.pretty_inspect.should ==
          "Rattler::Util::Node[\"aa\", \"bb\", :foo=>\"bar\"]\n"
      end
    end
  end

end
