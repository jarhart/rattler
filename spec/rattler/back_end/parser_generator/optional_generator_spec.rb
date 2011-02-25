require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::ParserGenerator
include Rattler::Parsers

describe OptionalGenerator do

  include ParserGeneratorSpecHelper

  let(:optional) { Optional[Match[/w+/]] }

  describe '#gen_basic' do

    context 'when nested' do
      it 'generates nested optional matching code' do
        nested_code {|g| g.gen_basic optional }.
          should == '((r = @scanner.scan(/w+/)) ? [r] : [])'
      end
    end

    context 'when top-level' do
      it 'generates top level optional matching code' do
        top_level_code {|g| g.gen_basic optional }.
          should == '(r = @scanner.scan(/w+/)) ? [r] : []'
      end
    end
  end

  describe '#gen_assert' do

    context 'when nested' do
      it 'generates "true"' do
        nested_code {|g| g.gen_assert optional }.should == 'true'
      end
    end

    context 'when top-level' do
      it 'generates "true"' do
        top_level_code {|g| g.gen_assert optional }.should == 'true'
      end
    end
  end

  describe '#gen_disallow' do

    context 'when nested' do
      it 'generates "false"' do
        nested_code {|g| g.gen_disallow optional }.should == 'false'
      end
    end

    context 'when top-level' do
      it 'generates "false"' do
        top_level_code {|g| g.gen_disallow optional }.should == 'false'
      end
    end
  end

  describe '#gen_dispatch_action' do

    let(:code) { DispatchActionCode.new('Word', 'parsed') }

    context 'when nested' do
      it 'generates nested optional matching code with a dispatch action' do
        nested_code {|g| g.gen_dispatch_action optional, code }.
          should == (<<-CODE).strip
begin
  r = @scanner.scan(/w+/)
  Word.parsed(r ? [r] : [])
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level optional matching code with a dispatch action' do
        top_level_code {|g| g.gen_dispatch_action optional, code }.
          should == (<<-CODE).strip
r = @scanner.scan(/w+/)
Word.parsed(r ? [r] : [])
          CODE
      end
    end
  end

  describe '#gen_direct_action' do

    let(:code) { ActionCode.new('|_| _.size') }

    context 'when nested' do
      it 'generates nested optional matching code with a direct action' do
        nested_code {|g| g.gen_direct_action optional, code }.
          should == (<<-CODE).strip
begin
  r = @scanner.scan(/w+/)
  ((r ? [r] : []).size)
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level optional matching code with a direct action' do
        top_level_code {|g| g.gen_direct_action optional, code }.
          should == (<<-CODE).strip
r = @scanner.scan(/w+/)
((r ? [r] : []).size)
          CODE
      end
    end
  end

  describe '#gen_token' do

    context 'when nested' do
      it 'generates nested optional matching code' do
        nested_code {|g| g.gen_token optional }.
          should == (<<-CODE).strip
begin
  @scanner.scan(/w+/) || ''
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level optional matching code' do
        top_level_code {|g| g.gen_token optional }.
          should == "@scanner.scan(/w+/) || ''"
      end
    end
  end

  describe '#gen_skip' do

    context 'when nested' do
      it 'generates nested optional skipping code' do
        nested_code {|g| g.gen_skip optional }.
          should == (<<-CODE).strip
begin
  @scanner.skip(/w+/)
  true
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level optional skipping code' do
        top_level_code {|g| g.gen_skip optional }.
          should == (<<-CODE).strip
@scanner.skip(/w+/)
true
          CODE
      end
    end
  end

  describe '#gen_intermediate' do
    it 'generates nested optional matching code' do
      nested_code {|g| g.gen_intermediate optional }.
        should == '((r = @scanner.scan(/w+/)) ? [r] : [])'
    end
  end

  describe '#gen_intermediate_assert' do
    it 'generates "true"' do
      nested_code {|g| g.gen_intermediate_assert optional }.should == 'true'
    end
  end

  describe '#gen_intermediate_disallow' do
    it 'generates "false"' do
      nested_code {|g| g.gen_intermediate_disallow optional }.should == 'false'
    end
  end

  describe '#gen_intermediate_skip' do
    it 'generates nested optional skipping code' do
      nested_code {|g| g.gen_intermediate_skip optional }.
        should == (<<-CODE).strip
begin
  @scanner.skip(/w+/)
  true
end
        CODE
    end
  end

end
