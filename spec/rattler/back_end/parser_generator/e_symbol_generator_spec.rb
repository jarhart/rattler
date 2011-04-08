require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::ParserGenerator
include Rattler::Parsers

describe ESymbolGenerator do

  include ParserGeneratorSpecHelper

  describe '#gen_basic' do

    context 'when nested' do
      it 'generates nested eof matching code' do
        nested_code {|g| g.gen_basic ESymbol[] }.should == 'true'
      end
    end

    context 'when top-level' do
      it 'generates top level eof matching code' do
        top_level_code {|g| g.gen_basic ESymbol[] }.should == 'true'
      end
    end
  end

  describe '#gen_assert' do

    context 'when nested' do
      it 'generates nested eof matching code' do
        nested_code {|g| g.gen_assert ESymbol[] }.should == 'true'
      end
    end

    context 'when top-level' do
      it 'generates top level eof matching code' do
        top_level_code {|g| g.gen_assert ESymbol[] }.should == 'true'
      end
    end
  end

  describe '#gen_disallow' do

    context 'when nested' do
      it 'generates nested eof disallowing code' do
        nested_code {|g| g.gen_disallow ESymbol[] }.should == 'false'
      end
    end

    context 'when top-level' do
      it 'generates top level eof disallowing code' do
        top_level_code {|g| g.gen_disallow ESymbol[] }.should == 'false'
      end
    end
  end

  describe '#gen_dispatch_action' do

    let(:code) { NodeCode.new('Word', 'parsed') }

    context 'when nested' do
      it 'generates nested eof matching code with a dispatch action' do
        nested_code {|g| g.gen_dispatch_action ESymbol[], code }.
          should == 'Word.parsed([])'
      end
    end

    context 'when top-level' do
      it 'generates top level eof matching code with a dispatch action' do
        top_level_code {|g| g.gen_dispatch_action ESymbol[], code }.
          should == 'Word.parsed([])'
      end
    end
  end

  describe '#gen_direct_action' do

    let(:code) { ActionCode.new(':foo') }

    context 'when nested' do
      it 'generates nested eof matching code with a direct action' do
        nested_code {|g| g.gen_direct_action ESymbol[], code }.
          should == '(:foo)'
      end
    end

    context 'when top-level' do
      it 'generates top level eof matching code with a direct action' do
        top_level_code {|g| g.gen_direct_action ESymbol[], code }.
          should == ':foo'
      end
    end
  end

  describe '#gen_token' do

    context 'when nested' do
      it 'generates nested eof matching code matching as ""' do
        nested_code {|g| g.gen_token ESymbol[] }.
          should == "''"
      end
    end

    context 'when top-level' do
      it 'generates top level eof matching code matching as ""' do
        top_level_code {|g| g.gen_token ESymbol[] }.
          should == "''"
      end
    end
  end

  describe '#gen_skip' do

    context 'when nested' do
      it 'generates nested eof skipping code' do
        nested_code {|g| g.gen_skip ESymbol[] }.should == 'true'
      end
    end

    context 'when top-level' do
      it 'generates top level eof skipping code' do
        top_level_code {|g| g.gen_skip ESymbol[] }.should == 'true'
      end
    end
  end

  describe '#gen_intermediate' do
    it 'generates basic eof matching code' do
      nested_code {|g| g.gen_intermediate ESymbol[] }.should == 'true'
    end
  end

  describe '#gen_intermediate_assert' do
    it 'generates intermediate eof matching code' do
      nested_code {|g| g.gen_intermediate_assert ESymbol[] }.should == 'true'
    end
  end

  describe '#gen_intermediate_disallow' do
    it 'generates intermediate eof disallowing code' do
      nested_code {|g| g.gen_intermediate_disallow ESymbol[] }.should == 'false'
    end
  end

  describe '#gen_intermediate_skip' do
    it 'generates intermediate eof skipping code' do
      nested_code {|g| g.gen_intermediate_skip ESymbol[] }.should == 'true'
    end
  end

end
