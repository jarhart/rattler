require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Label do
  include CombinatorParserSpecHelper

  subject { Label[:name, [Match[/\w+/]]] }

  describe '#parse' do

    it 'matches identically to its parser' do
      parsing('abc123  ').should result_in('abc123').at(6)
      parsing('==').should fail
    end

    context 'on success' do
      it 'adds a mapping from its label to its result' do
        parsing('foo  ').should result_in('foo').with_scope(:name => 'foo')
      end
    end
  end

  describe '#capturing?' do

    context 'with a capturing parser' do
      it 'is true' do
        subject.should be_capturing
      end
    end

    context 'with a non-capturing parser' do
      subject { Label[:name, [Skip[Match[/\s+/]]]] }
      it 'is false' do
        subject.should_not be_capturing
      end
    end

  end

end
