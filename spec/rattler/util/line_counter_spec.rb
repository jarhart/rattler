require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include Rattler::Util

describe LineCounter do
  
  subject do
    LineCounter.new(<<-EOS)
require 'rattler'

grammar Rattler::Grammar::Metagrammar

%whitespace (space+ | ('#' [^\n]*))* {
  
  grammar <-  heading rules EOF
  
    EOS
  end
  
  describe '#line' do
    it 'starts at 1' do
      subject.line(0).should == 1
    end
    
    context 'given an index on the first line' do
      it 'returns 1' do
        subject.line(10).should == 1
      end
    end
    
    context 'given an index on a line with text' do
      it 'returns the line number' do
        subject.line(20).should == 3
      end
    end
    
    context 'given an index on a blank line' do
      it 'returns the line number' do
        subject.line(57).should == 4
      end
    end
  end
  
  describe '#column' do
    it 'starts at 1' do
      subject.column(0).should == 1
    end
    
    context 'given an index on the first line' do
      it 'returns (index + 1)' do
        subject.column(10).should == 11
        subject.column(16).should == 17
      end
    end
    
    context 'given an index on a line with text' do
      it 'returns the column number at the index on that line' do
        subject.column(20).should == 2
        subject.column(26).should == 8
      end
    end
    
    context 'given an index on a blank line' do
      it 'returns 1' do
        subject.column(57).should == 1
      end
    end
    
    context 'with text containing tabs' do
      subject do
        LineCounter.new("\tgrammar FooGrammar\n\n\t\texpr\t<-\t'foo'\n")
      end
      
      it 'counts initial tabs as 8 spaces' do
        subject.column(1).should == 9
        subject.column(22).should == 9
        subject.column(23).should == 17
      end
      
      it 'counts tabs as enough spaces to get to the next tab stop' do
        subject.column(28).should == 25
        subject.column(31).should == 33
      end
    end
    
    context 'with text containing tabs and a tab_size of 4' do
      subject do
        LineCounter.new("\tgrammar FooGrammar\n\n\t\texpr\t<-\t'foo'\n", :tab_size => 4)
      end
      
      it 'counts initial tabs as 4 spaces' do
        subject.column(1).should == 5
        subject.column(22).should == 5
        subject.column(23).should == 9
      end
      
      it 'counts tabs as enough spaces to get to the next tab stop' do
        subject.column(28).should == 17
        subject.column(31).should == 21
      end
    end
  end
  
end
