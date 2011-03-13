require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rattler::Parsers::BackReference do
  include CombinatorParserSpecHelper

  subject { BackReference[:a] }

  describe '#parse' do

    let(:scope) { {:a => 'foo'} }

    context 'when the referenced parse result is next in the input' do
      it 'succeeds returning the matched string' do
        parsing('foobar  ').should result_in('foo').at(3)
      end
    end

    context 'when the referenced parse result is not next in the input' do
      it 'fails' do
        parsing('abc').should fail
      end
    end

  end

  describe '#capturing?' do
    it 'is true' do
      subject.should be_capturing
    end
  end

  describe '#re_source' do
    it 'returns the source for a Regexp that will match the referenced result' do
      subject.re_source(:a => 'r0').should == '#{r0}'
    end
  end

end
