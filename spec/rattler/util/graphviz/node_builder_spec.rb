require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
require 'set'

describe Rattler::Util::GraphViz::NodeBuilder do

  describe '#array_like?' do

    context 'given an array' do
      it 'returns true' do
        subject.array_like?(['a']).should be_true
      end
    end

    context 'given a hash' do
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

      it 'iterates over the pairs' do
        children = Set[]
        subject.each_child_of(object) {|_| children << _ }
        children.should == Set[[:a, ['a1', 'a2']], [:b, 'b']]
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
