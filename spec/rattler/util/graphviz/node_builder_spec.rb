require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
require 'set'

describe Rattler::Util::GraphViz::NodeBuilder do

  describe '#node_label' do

    context 'given a number' do
      it 'returns a number as a string' do
        subject.node_label(42).should == '42'
      end
    end

    context 'given a string' do
      it 'returns the string surrounded by escaped quotes' do
        subject.node_label('abc').should == '"abc"'
      end
    end

    context 'given an unnamed record-like object' do
      it 'returns a record label with the class name' do
        subject.node_label(Rattler::Util::Node[]).should == '{Rattler::Util::Node}'
      end
    end

    context 'given a named record-like object' do
      it 'returns a record label with a name' do
        subject.node_label(Rattler::Util::Node[{:name => 'IDENT'}]).
          should == '{IDENT}'
      end
    end

    context 'given an array-like object' do
      it 'returns "[]" escaped' do
        subject.node_label(['let', 'x', '=', '1']).should == '\\[\\]'
      end
    end

    context 'given a hash with compound values' do
      it 'returns "{}" escaped' do
        subject.node_label({:a => 'a', :b => ['a1', 'a2']}).should == '\\{\\}'
      end
    end
  end

  describe '#array_like?' do

    context 'given an array' do
      it 'returns true' do
        subject.array_like?(['a']).should be_true
      end
    end

    context 'given a simple hash' do
      it 'returns true' do
        subject.array_like?({:a => 'a'}).should be_true
      end
    end

    context 'given a string' do
      it 'returns false' do
        subject.array_like?('a').should be_false
      end
    end
  end

  describe '#record_like?' do

    context 'given a hash of simple values' do
      it 'returns true' do
        subject.record_like?({:a => 'a', :b => 'b'}).should be_true
      end
    end

    context 'given a hash with compound values' do
      it 'returns false' do
        subject.record_like?({:a => ['a1', 'a2'], :b => 'b'}).should be_false
      end
    end

    context 'given an array' do
      it 'returns false' do
        subject.record_like?(['a']).should be_false
      end
    end
  end

  describe '#each_child_of' do

    context 'given an array' do

      let(:object) { ['a', 'b', 'c'] }

      it 'iterates over the members' do
        children = []
        subject.each_child_of(object) {|_| children << _ }
        children.should == ['a', 'b', 'c']
      end
    end

    context 'given a hash with compound values' do

      let(:object) { {:a => ['a1', 'a2'], :b => 'b'} }

      it 'iterates over the pairs yielding Mappings' do
        children = Set[]
        subject.each_child_of(object) {|_| children << _ }
        children.should have(2).mappings
      end
    end

    context 'given a hash with simple values' do

      let(:object) { {:a => 'a', :b => 'b'} }

      it 'does nothing' do
        children = Set[]
        subject.each_child_of(object) {|_| children << _}
        children.should be_empty
      end
    end
  end

end
