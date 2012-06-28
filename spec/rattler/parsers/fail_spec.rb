require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include Rattler::Parsers

describe Rattler::Parsers::Fail do
  include CombinatorParserSpecHelper

  subject { Fail[:expr, 'malformed expression'] }

  describe '#parse' do
    it 'fails' do
      parsing('anything').should fail
    end
  end

  describe '#capturing?' do
    it 'is false' do
      subject.should_not be_capturing
    end
  end

  describe '#capturing_decidable?' do
    it 'is true' do
      subject.should be_capturing_decidable
    end
  end

end
