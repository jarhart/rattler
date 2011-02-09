require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rattler::Parsers::Optional do
  include CombinatorParserSpecHelper
  
  describe '#parse' do
    
    context 'with a capturing parser' do
      
      subject { Optional[Match[/\w+/]] }
      
      context 'when the parser matches' do
        it 'matches returning the result in an array' do
          parsing('foo').should result_in(['foo']).at(3)
        end
      end
      
      context 'when the parser fails' do
        it 'matches returning an empty array' do
          parsing('   ').should result_in([]).at(0)
        end
      end
      
    end
    
    context 'with a non-capturing parser' do
      
      subject { Optional[Skip[Match[/\w+/]]] }
      
      context 'when the parser matches' do
        it 'matches returning true' do
          parsing('foo').should result_in(true).at(3)
        end
      end
      
      context 'when the parser fails' do
        it 'matches returning true' do
          parsing('   ').should result_in(true).at(0)
        end
      end
      
    end
    
  end
  
  describe '#capturing?' do
    
    context 'with a capturing parser' do
      subject { Optional[Match[/\w+/]] }
      it 'is true' do
        subject.should be_capturing
      end
    end
    
    context 'with a non-capturing parser' do
      subject { Optional[Skip[Match[/\s*/]]] }
      it 'is false' do
        subject.should_not be_capturing
      end
    end
    
  end
  
end
