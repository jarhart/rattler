require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Parsers

describe Rattler::BackEnd::ParserGenerator::FailGenerator do
  
  include ParserGeneratorSpecHelper
  
  describe '#gen_basic' do
    
    context 'when nested' do
      context 'and fail type is :expr' do
        
        let(:fail) { Fail[:expr, 'operator expected'] }
        
        it 'generates a nested fail expression' do
          nested_code {|g| g.gen_basic fail }.
          should == '(fail! { "operator expected" })'
        end
      end
      
      context 'and fail type is :rule' do
        
        let(:fail) { Fail[:rule, 'identifier expected'] }
        
        it 'generates a nested return statement returning a fail expression' do
          nested_code {|g| g.gen_basic fail }.
          should == (<<-CODE).strip
return(fail! { "identifier expected" })
false
          CODE
        end
      end
      
      context 'and fail type is :parse' do
        
        let(:fail) { Fail[:parse, 'unexpected operator'] }
        
        it 'generates a nested fail_parse statement' do
          nested_code {|g| g.gen_basic fail }.
          should == '(fail_parse { "unexpected operator" })'
        end
      end
    end
    
    context 'when top-level' do
      context 'and fail type is :expr' do
        
        let(:fail) { Fail[:expr, 'operator expected'] }
        
        it 'generates a top-level fail expression' do
          top_level_code {|g| g.gen_basic fail }.
          should == 'fail! { "operator expected" }'
        end
      end
      
      context 'and fail type is :rule' do
        
        let(:fail) { Fail[:rule, 'identifier expected'] }
        
        it 'generates a return statement returning a fail expression' do
          top_level_code {|g| g.gen_basic fail }.
          should == 'return(fail! { "identifier expected" })'
        end
      end
      
      context 'and fail type is :parse' do
        
        let(:fail) { Fail[:parse, 'unexpected operator'] }
        
        it 'generates a top-level fail_parse statement' do
          top_level_code {|g| g.gen_basic fail }.
          should == 'fail_parse { "unexpected operator" }'
        end
      end
    end
    
  end
  
end
