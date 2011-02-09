require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rattler::Parsers::Match do
  include CombinatorParserSpecHelper
  
  subject { Match[/\w+/] }
  
  describe '#parse' do
    
    context 'when the regexp matches' do
      it 'succeeds returning the matched string' do
        parsing('abc123  ').should result_in('abc123').at(6)
      end
    end
    
    context 'when the regexp does not match' do
      it 'fails' do
        parsing('  abc').should fail
        parsing('==').should fail
      end
    end
    
  end
  
  describe '#capturing?' do
    it 'is true' do
      subject.should be_capturing
    end
  end
  
end
