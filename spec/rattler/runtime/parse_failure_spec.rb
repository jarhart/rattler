require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include Rattler::Runtime

describe ParseFailure do
  
  let(:source) do
    <<-EOS
void foo() {
  bar()
}
    EOS
  end
  
  describe '#message' do
    
    context 'when initialized with no message' do
      
      subject { ParseFailure.new(source, 20) }
      
      it 'returns nil' do
        subject.message.should be_nil
      end
    end
    
    context 'when initialized with a message' do
      
      subject { ParseFailure.new(source, 20, 'unrecognized operator') }
      
      it 'returns the message' do
        subject.message.should == 'unrecognized operator'
      end
    end
    
    context 'when initialized with a rule name' do
      
      subject { ParseFailure.new(source, 20, :identifier) }
      
      it 'returns a representation using "<rule name> expected"' do
        subject.message.should == 'identifier expected'
      end
    end
  end
  
  describe '#to_s' do
    context 'when initialized with no message' do
      
      subject { ParseFailure.new(source, 20) }
      
      it 'returns a generic representation' do
        subject.to_s.should == 'parse error at line 2, column 8'
      end
    end
    
    context 'when initialized with a message' do
      
      subject { ParseFailure.new(source, 20, 'unrecognized operator') }
      
      it 'returns a representation using the message' do
        subject.to_s.
          should == "parse error at line 2, column 8:\n unrecognized operator"
      end
    end
    
    context 'when initialized with a rule name' do
      
      subject { ParseFailure.new(source, 20, :identifier) }
      
      it 'returns a representation using "<rule name> expected"' do
        subject.to_s.
          should == "parse error at line 2, column 8:\n identifier expected"
      end
    end
  end
  
  describe '#line' do
    it 'return the line number of the failure position' do
      ParseFailure.new(source, 20).line.should == 2
    end
  end
  
  describe '#column' do
    it 'return the column number of the failure position' do
      ParseFailure.new(source, 20).column.should == 8
    end
  end
  
end
