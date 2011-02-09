require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rattler::Runtime::Parser do
  
  subject { Rattler::Runtime::Parser.new('Hello World!') }
  
  describe '#fail' do
    
    context 'before any parse failures have occurred' do
      
      context 'with no arguments' do
        before do
          subject.pos = 4
          subject.fail
        end
        it 'registers a parse failure' do
          subject.failure.pos.should == 4
        end
      end
      
      context 'given a message' do
        before { subject.fail { 'unexpected end-of-line' } }
        
        it 'registers the parse failure with the message' do
          subject.failure.message.should == 'unexpected end-of-line'
        end
      end
      
      context 'given a rule name' do
        before { subject.fail { :identifier } }
        
        it 'registers the failure with a "<rule name> expected" message' do
          subject.failure.message.should == 'identifier expected'
        end
      end
    end
    
    context 'after other parse failures have occurred' do
      before do
        subject.pos = 4
        subject.fail { 'unexpected end-of-line' }
      end
      
      context 'at a later position than the current registered failure' do
        before do
          subject.pos = 5
          subject.fail { 'a later failure' }
        end
        it 'replaces the current registered failure' do
          subject.failure.pos.should == 5
          subject.failure.message.should == 'a later failure'
        end
      end
      
      context 'at an earlier position than the current registered failure' do
        before do
          subject.pos = 3
          subject.fail { 'an earlier failure' }
        end
        it 'preserves the current registered failure' do
          subject.failure.pos.should == 4
          subject.failure.message.should == 'unexpected end-of-line'
        end
      end
      
      context 'at the same position as the current registered failure' do
        before do
          subject.pos = 4
          subject.fail { 'another failure' }
        end
        it 'preserves the current registered failure' do
          subject.failure.pos.should == 4
          subject.failure.message.should == 'unexpected end-of-line'
        end
      end
    end
  end
  
  describe '#failure' do
    
    context 'before any parse failures have occurred' do
      it 'returns no failure' do
        subject.failure.should_not be
      end
    end
    
    context 'after a parse failure has occurred' do
      before do
        subject.pos = 4
        subject.fail { 'variable expected' }
      end
      it 'returns a failure object' do
        subject.failure.pos.should == 4
        subject.failure.message.should == 'variable expected'
      end
    end
  end
  
end
