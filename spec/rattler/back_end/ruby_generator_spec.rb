require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rattler::BackEnd::RubyGenerator do
  
  subject { Rattler::BackEnd::RubyGenerator.new }
  
  describe '<<' do
    it 'concatenates code' do
      (subject << 'foo' << '(:bar)').code.should == 'foo(:bar)'
    end
  end
  
  describe '#newline' do
    it 'starts new lines' do
      ((subject << 'foo').newline << 'bar').code.should == "foo\nbar"
    end
  end
  
  describe '#indent' do
    it 'indents lines' do
      subject.indent { (subject << 'foo').newline << 'bar' }.code.
        should == "\n  foo\n  bar"
    end
  end
  
  describe '#surround' do
    it 'surrounds code with the given prefix and suffix' do
      subject.surround('(', ')') { subject << 'foo' }.code.should == '(foo)'
    end
  end
  
  describe '#block' do
    it 'generates blocks' do
      subject.block('for n in names') { subject << 'puts n' }.code.
        should == "for n in names\n  puts n\nend"
    end
  end
  
  describe '#intersperse' do
    context 'given the :sep option by itself' do
      it 'intersperses the separator without newlines' do
        subject.intersperse(['a', 'b', 'c'], :sep => ' + ') do |_|
          subject << (_ * 2)
        end.code.should == "aa + bb + cc"
      end
    end
    
    context 'given :newline => true' do
      it 'intersperses the separator with single newlines' do
        subject.intersperse(['a', 'b', 'c'], :sep => ' +', :newline => true) do |_|
          subject << (_ * 2)
        end.code.should == "aa +\nbb +\ncc"
      end
    end
    
    context 'given :newlines => n' do
      it 'intersperses separators with multiple newlines' do
        subject.intersperse(['a', 'b', 'c'], :sep => ' +', :newlines => 2) do |_|
          subject << (_ * 2)
        end.code.should == "aa +\n\nbb +\n\ncc"
      end
    end
    
    context 'given :newlines => n and no :sep option' do
      it 'intersperses the newlines without any other separator' do
        subject.intersperse(['a', 'b', 'c'], :newline => true) do |_|
          subject << (_ * 2)
        end.code.should == "aa\nbb\ncc"
      end
    end
  end
  
end
