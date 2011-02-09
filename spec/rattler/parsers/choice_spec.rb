require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Choice do
  include CombinatorParserSpecHelper
  
  describe '#parse' do
    
    subject { Choice[Match[/[[:alpha:]]+/], Match[/[[:digit:]]+/]] }
    
    context 'when any of the parsers match' do
      it 'matches the same as the first parser that matches' do
        parsing('abc123').should result_in('abc').at(3)
        parsing('123abc').should result_in('123').at(3)
      end
    end
    
    context 'when none of the parsers match' do
      it 'fails' do
        parsing('==').should fail
      end
    end
    
    context 'with no capturing parsers' do
      subject do
        Choice[Skip[Match[/[[:alpha:]]+/]], Skip[Match[/[[:digit:]]+/]]]
      end
      
      context 'when any of the parsers match' do
        it 'returns true' do
          parsing('abc123').should result_in(true).at(3)
          parsing('123abc').should result_in(true).at(3)
        end
      end
    end
    
  end
  
  describe '#capturing?' do
    
    context 'with any capturing parsers' do
      subject do
        Choice[Skip[Match[/[[:space:]]*/]], Match[/[[:alpha:]]+/]]
      end
      it 'is true' do
        subject.should be_capturing
      end
    end
    
    context 'with no capturing parsers' do
      subject do
        Choice[Skip[Match[/[[:alpha:]]+/]], Skip[Match[/[[:digit:]]+/]]]
      end
      it 'is false' do
        subject.should_not be_capturing
      end
    end
    
  end
  
end
