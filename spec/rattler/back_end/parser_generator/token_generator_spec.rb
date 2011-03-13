require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::ParserGenerator
include Rattler::Parsers

describe TokenGenerator do

  include ParserGeneratorSpecHelper

  let(:token) { Token[Match[/\w+/]] }

  describe '#gen_basic' do

    context 'when nested' do
      it 'generates nested token matching code' do
        nested_code {|g| g.gen_basic token }.
          should == '@scanner.scan(/\w+/)'
      end
    end

    context 'when top-level' do
      it 'generates top level token matching code' do
        top_level_code {|g| g.gen_basic token }.
          should == '@scanner.scan(/\w+/)'
      end
    end
  end

  describe '#gen_assert' do

    context 'when nested' do
      it 'generates nested positive lookahead code' do
        nested_code {|g| g.gen_assert token }.
          should == '(@scanner.skip(/(?=\w+)/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level positive lookahead code' do
        top_level_code {|g| g.gen_assert token }.
          should == '@scanner.skip(/(?=\w+)/) && true'
      end
    end
  end

  describe '#gen_disallow' do

    context 'when nested' do
      it 'generates nested negative lookahead code' do
        nested_code {|g| g.gen_disallow token }.
          should == '(@scanner.skip(/(?!\w+)/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level negative lookahead code' do
        top_level_code {|g| g.gen_disallow token }.
          should == '@scanner.skip(/(?!\w+)/) && true'
      end
    end
  end

  describe '#gen_dispatch_action' do

    let(:code) { NodeCode.new('Word', 'parsed') }

    context 'when nested' do
      it 'generates nested matching code with a dispatch action' do
        nested_code {|g| g.gen_dispatch_action token, code }.
          should == (<<-CODE).strip
begin
  (r = @scanner.scan(/\\w+/)) &&
  Word.parsed([r])
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level matching code with a dispatch action' do
        top_level_code {|g| g.gen_dispatch_action token, code }.
          should == (<<-CODE).strip
(r = @scanner.scan(/\\w+/)) &&
Word.parsed([r])
          CODE
      end
    end
  end

  describe '#gen_direct_action' do

    let(:code) { ActionCode.new('|_| _.to_sym') }

    context 'when nested' do
      it 'generates nested matching code with a direct action' do
        nested_code {|g| g.gen_direct_action token, code }.
          should == (<<-CODE).strip
begin
  (r = @scanner.scan(/\\w+/)) &&
  (r.to_sym)
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level matching code with a direct action' do
        top_level_code {|g| g.gen_direct_action token, code }.
          should == (<<-CODE).strip
(r = @scanner.scan(/\\w+/)) &&
(r.to_sym)
          CODE
      end
    end
  end

  describe '#gen_token' do

    context 'when nested' do
      it 'generates nested token matching code' do
        nested_code {|g| g.gen_token token }.
          should == '@scanner.scan(/\w+/)'
      end
    end

    context 'when top-level' do
      it 'generates top level token matching code' do
        top_level_code {|g| g.gen_token token }.
          should == '@scanner.scan(/\w+/)'
      end
    end
  end

  describe '#gen_skip' do

    context 'when nested' do
      it 'generates nested skipping code' do
        nested_code {|g| g.gen_skip token }.
          should == '(@scanner.skip(/\w+/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level skipping code' do
        top_level_code {|g| g.gen_skip token }.
          should == '@scanner.skip(/\w+/) && true'
      end
    end
  end

  describe '#gen_intermediate' do
    it 'generates nested token matching code' do
      nested_code {|g| g.gen_intermediate token }.
        should == '@scanner.scan(/\w+/)'
    end
  end

  describe '#gen_intermediate_assert' do
    it 'generates intermediate positive lookahead code' do
      nested_code {|g| g.gen_intermediate_assert token }.
        should == '@scanner.skip(/(?=\w+)/)'
    end
  end

  describe '#gen_intermediate_disallow' do
    it 'generates intermediate negative lookahead code' do
      nested_code {|g| g.gen_intermediate_disallow token }.
        should == '@scanner.skip(/(?!\w+)/)'
    end
  end

  describe '#gen_intermediate_skip' do
    it 'generates intermediate skipping code' do
      nested_code {|g| g.gen_intermediate_skip token }.
        should == '@scanner.skip(/\w+/)'
    end
  end

end
