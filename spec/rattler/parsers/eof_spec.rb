require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Eof do
  include CombinatorParserSpecHelper

  subject { Eof[] }
  
  describe '#parse' do
    
    context 'at the end of the source' do
      it 'returns true' do
        parsing('abc123').at(6).should result_in(true).at(6)
      end
    end
    
    context 'before the end of the source' do
      it 'fails' do
        parsing('abc123').at(5).should fail
      end
    end
    
  end
  
  describe '#capturing?' do
    it 'is false' do
      subject.should_not be_capturing
    end
  end
  
end
