require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rattler::Parsers::ParserScope do

  describe '.empty' do

    subject { described_class.empty }

    it 'has no bindings' do
      subject.bindings.should be_empty
    end

    it 'has no captures' do
      subject.captures.should be_empty
    end
  end

  describe '#bind' do

    subject { described_class.empty }

    it 'returns a new scope with the given bindings' do
      scope = subject.bind(:a => 'foo', :b => 'bar')
      scope.bindings[:a].should == 'foo'
      scope.bindings[:b].should == 'bar'
    end

    context 'given a binding with an already bound name' do

      subject { described_class.new(:a => 'foo') }

      it 'shadows the existing binding with the new binding' do
        subject.bind(:a => 'bar').bindings[:a].should == 'bar'
      end
    end

    context 'with existing captures' do

      subject { described_class.new({}, ['foo', 'bar']) }

      it 'includes the captures in the new scope' do
        subject.bind(:a => 'foo').captures.should == ['foo', 'bar']
      end
    end
  end

  describe '#capture' do

    subject { described_class.empty }

    it 'returns a new scope with the given captures' do
      subject.capture('foo', 'bar').captures.should == ['foo', 'bar']
    end

    context 'with existing captures' do

      subject { described_class.new({}, ['foo', 'bar']) }

      it 'returns a new scope with the given captures appended' do
        subject.capture('baz').captures.should == ['foo', 'bar', 'baz']
      end
    end

    context 'with existing bindings' do

      subject { described_class.new(:a => 'foo') }

      it 'includes the bindings in the new scope' do
        subject.capture('baz').bindings[:a].should == 'foo'
      end
    end
  end

  describe '#nest' do

    subject { described_class.new({:a => 'baz'}, ['foo', 'bar']) }

    it 'returns a new scope with the same bindings but no captures' do
      subject.nest.bindings[:a].should == 'baz'
      subject.nest.captures.should be_empty
    end
  end

  describe '#merge' do

    subject { described_class.new({:a => 'baz'}, ['foo', 'bar']) }
    let(:other) { described_class.new({:b => 'fez'}, ['boo'] ) }

    it 'returns a new scope with bindings from the other scope' do
      merged = subject.merge(other)
      merged.bindings[:a].should == 'baz'
      merged.bindings[:b].should == 'fez'
      merged.captures.should == ['foo', 'bar']
    end
  end

  describe '#[]' do

    subject { described_class.new(:a => 'foo') }

    it 'returns bindings' do
      subject[:a].should == 'foo'
    end
  end
end
