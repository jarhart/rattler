require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Token do
  include CombinatorParserSpecHelper
  
  describe '#parse' do
    
    subject do
      Token[Sequence[Match[/[[:alpha:]]+/], Match[/\=/], Match[/[[:digit:]]+/]]]
    end
    
    context 'when the parser matches' do
      it 'matches returning the entire matched string' do
        parsing('val=42 ').should result_in('val=42').at(6)
      end
    end
    
    context 'when the parser fails' do
      it 'fails' do
        parsing('val=x').should fail
      end
    end
    
    context 'with a non-capturing parser' do
      
      subject { Token[Skip[Match[/\w+/]]] }
      
      context 'when the parser matches' do
        it 'matches returning the entire matched string' do
          parsing('abc123 ').should result_in('abc123').at(6)
        end
      end
    end
    
  end
  
  describe '#capturing?' do
    
    subject { Token[Match[/\w+/]] }
    
    it 'is true' do
      subject.should be_capturing
    end
    
    context 'with a non-capturing parser' do
      subject { Token[Skip[Match[/\s*/]]] }
      it 'is true' do
        subject.should be_capturing
      end
    end
    
  end
  
end
