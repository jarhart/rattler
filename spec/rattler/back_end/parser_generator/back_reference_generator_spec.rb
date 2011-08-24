require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::ParserGenerator
include Rattler::Parsers

describe BackReferenceGenerator do

  include ParserGeneratorSpecHelper

  let(:ref) { BackReference[:a] }

  let(:scope) { ParserScope.new(bindings) }
  let(:bindings) { {:a => 'r0_2'} }

  describe '#gen_basic' do

    context 'when nested' do
      it 'generates nested regex matching code' do
        nested_code {|g| g.gen_basic ref, scope }.
          should == '@scanner.scan(/#{r0_2}/)'
      end
    end

    context 'when top-level' do
      it 'generates top level regex matching code' do
        top_level_code {|g| g.gen_basic ref, scope }.
          should == '@scanner.scan(/#{r0_2}/)'
      end
    end
  end

  describe '#gen_assert' do

    context 'when nested' do
      it 'generates nested regex positive lookahead code' do
        nested_code {|g| g.gen_assert ref, scope }.
          should == '(@scanner.skip(/(?=#{r0_2})/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level regex positive lookahead code' do
        top_level_code {|g| g.gen_assert ref, scope }.
          should == '@scanner.skip(/(?=#{r0_2})/) && true'
      end
    end
  end

  describe '#gen_disallow' do

    context 'when nested' do
      it 'generates nested regex negative lookahead code' do
        nested_code {|g| g.gen_disallow ref, scope }.
          should == '(@scanner.skip(/(?!#{r0_2})/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level regex negative lookahead code' do
        top_level_code {|g| g.gen_disallow ref, scope }.
          should == '@scanner.skip(/(?!#{r0_2})/) && true'
      end
    end
  end

  describe '#gen_dispatch_action' do

    let(:code) { NodeCode.new('Word', 'parsed') }

    context 'when nested' do
      it 'generates nested regex matching code with a dispatch action' do
        nested_code {|g| g.gen_dispatch_action ref, code, scope }.
          should == (<<-CODE).strip
begin
  (r = @scanner.scan(/\#{r0_2}/)) &&
  Word.parsed([r], :labeled => {:a => r0_2})
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level regex matching code with a dispatch action' do
        top_level_code {|g| g.gen_dispatch_action ref, code, scope }.
          should == (<<-CODE).strip
(r = @scanner.scan(/\#{r0_2}/)) &&
Word.parsed([r], :labeled => {:a => r0_2})
          CODE
      end
    end
  end

  describe '#gen_direct_action' do

    let(:code) { ActionCode.new('|_| _.to_sym') }

    context 'when nested' do
      it 'generates nested regex matching code with a direct action' do
        nested_code {|g| g.gen_direct_action ref, code, scope }.
          should == (<<-CODE).strip
begin
  (r = @scanner.scan(/\#{r0_2}/)) &&
  (r.to_sym)
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level regex matching code with a direct action' do
        top_level_code {|g| g.gen_direct_action ref, code, scope }.
          should == (<<-CODE).strip
(r = @scanner.scan(/\#{r0_2}/)) &&
(r.to_sym)
          CODE
      end
    end
  end

  describe '#gen_token' do

    context 'when nested' do
      it 'generates nested regex matching code' do
        nested_code {|g| g.gen_token ref, scope }.
          should == '@scanner.scan(/#{r0_2}/)'
      end
    end

    context 'when top-level' do
      it 'generates top level regex matching code' do
        top_level_code {|g| g.gen_token ref, scope }.
          should == '@scanner.scan(/#{r0_2}/)'
      end
    end
  end

  describe '#gen_skip' do

    context 'when nested' do
      it 'generates nested regex skipping code' do
        nested_code {|g| g.gen_skip ref, scope }.
          should == '(@scanner.skip(/#{r0_2}/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level regex skipping code' do
        top_level_code {|g| g.gen_skip ref, scope }.
          should == '@scanner.skip(/#{r0_2}/) && true'
      end
    end
  end

  describe '#gen_intermediate' do
    it 'generates basic regex matching code' do
      nested_code {|g| g.gen_intermediate ref, scope }.
        should == '@scanner.scan(/#{r0_2}/)'
    end
  end

  describe '#gen_intermediate_assert' do
    it 'generates intermediate regex positive lookahead code' do
      nested_code {|g| g.gen_intermediate_assert ref, scope }.
        should == '@scanner.skip(/(?=#{r0_2})/)'
    end
  end

  describe '#gen_intermediate_disallow' do
    it 'generates intermediate regex negative lookahead code' do
      nested_code {|g| g.gen_intermediate_disallow ref, scope }.
        should == '@scanner.skip(/(?!#{r0_2})/)'
    end
  end

  describe '#gen_intermediate_skip' do
    it 'generates intermediate regex skipping code' do
      nested_code {|g| g.gen_intermediate_skip ref, scope }.
        should == '@scanner.skip(/#{r0_2}/)'
    end
  end

end
