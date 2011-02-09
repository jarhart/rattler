require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Parsers

describe Rattler::BackEnd::ParserGenerator::SkipGenerator do
  
  include ParserGeneratorSpecHelper
  
  let(:skip) { Skip[Match[/\w+/]] }
  
  describe '#gen_basic' do
    
    context 'when nested' do
      it 'generates nested skipping code' do
        nested_code {|g| g.gen_basic skip }.
          should == '(@scanner.skip(/\w+/) && true)'
      end
    end
    
    context 'when top-level' do
      it 'generates top level skipping code' do
        top_level_code {|g| g.gen_basic skip }.
          should == '@scanner.skip(/\w+/) && true'
      end
    end
  end
  
  describe '#gen_assert' do
    
    context 'when nested' do
      it 'generates nested positive lookahead code' do
        nested_code {|g| g.gen_assert skip }.
          should == '(@scanner.skip(/(?=\w+)/) && true)'
      end
    end
    
    context 'when top-level' do
      it 'generates top level positive lookahead code' do
        top_level_code {|g| g.gen_assert skip }.
          should == '@scanner.skip(/(?=\w+)/) && true'
      end
    end
  end
  
  describe '#gen_disallow' do
    
    context 'when nested' do
      it 'generates nested negative lookahead code' do
        nested_code {|g| g.gen_disallow skip }.
          should == '(@scanner.skip(/(?!\w+)/) && true)'
      end
    end
    
    context 'when top-level' do
      it 'generates top level negative lookahead code' do
        top_level_code {|g| g.gen_disallow skip }.
          should == '@scanner.skip(/(?!\w+)/) && true'
      end
    end
  end
  
  describe '#gen_dispatch_action' do
    
    context 'when nested' do
      it 'generates nested matching code with a dispatch action' do
        nested_code {|g| g.gen_dispatch_action skip, 'Word', 'parsed' }.
          should == (<<-CODE).strip
begin
  @scanner.skip(/\\w+/) &&
  Word.parsed([])
end
          CODE
      end
    end
    
    context 'when top-level' do
      it 'generates top level matching code with a dispatch action' do
        top_level_code {|g| g.gen_dispatch_action skip, 'Word', 'parsed' }.
          should == (<<-CODE).strip
@scanner.skip(/\\w+/) &&
Word.parsed([])
          CODE
      end
    end
  end
  
  describe '#gen_direct_action' do
    
    context 'when nested' do
      it 'generates nested matching code with a direct action' do
        nested_code {|g| g.gen_direct_action skip, ActionCode.new('[]') }.
          should == (<<-CODE).strip
begin
  @scanner.skip(/\\w+/) &&
  ([])
end
          CODE
      end
    end
    
    context 'when top-level' do
      it 'generates top level matching code with a direct action' do
        top_level_code {|g| g.gen_direct_action skip, ActionCode.new('[]') }.
          should == (<<-CODE).strip
@scanner.skip(/\\w+/) &&
([])
          CODE
      end
    end
  end
  
  describe '#gen_token' do
    
    context 'when nested' do
      it 'generates nested token matching code' do
        nested_code {|g| g.gen_token skip }.
          should == '@scanner.scan(/\w+/)'
      end
    end
    
    context 'when top-level' do
      it 'generates top level token matching code' do
        top_level_code {|g| g.gen_token skip }.
          should == '@scanner.scan(/\w+/)'
      end
    end
  end
  
  describe '#gen_skip' do
    
    context 'when nested' do
      it 'generates nested skipping code' do
        nested_code {|g| g.gen_skip skip }.
          should == '(@scanner.skip(/\w+/) && true)'
      end
    end
    
    context 'when top-level' do
      it 'generates top level skipping code' do
        top_level_code {|g| g.gen_skip skip }.
          should == '@scanner.skip(/\w+/) && true'
      end
    end
  end
  
  describe '#gen_intermediate' do
    it 'generates intermediate skipping code' do
      nested_code {|g| g.gen_intermediate skip }.
        should == '@scanner.skip(/\w+/)'
    end
  end
  
  describe '#gen_intermediate_assert' do
    it 'generates intermediate positive lookahead code' do
      nested_code {|g| g.gen_intermediate_assert skip }.
        should == '@scanner.skip(/(?=\w+)/)'
    end
  end
  
  describe '#gen_intermediate_disallow' do
    it 'generates intermediate negative lookahead code' do
      nested_code {|g| g.gen_intermediate_disallow skip }.
        should == '@scanner.skip(/(?!\w+)/)'
    end
  end
  
  describe '#gen_intermediate_skip' do
    it 'generates intermediate skipping code' do
      nested_code {|g| g.gen_intermediate_skip skip }.
        should == '@scanner.skip(/\w+/)'
    end
  end
  
end
