require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::ParserGenerator
include Rattler::Parsers

describe DisallowGenerator do

  include ParserGeneratorSpecHelper

  let(:disallow) { Disallow[Match[/\d/]] }

  describe '#gen_basic' do

    context 'when nested' do
      it 'generates nested negative lookahead code' do
        nested_code {|g| g.gen_basic disallow }.
          should == '(@scanner.skip(/(?!\d)/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level negative lookahead code' do
        top_level_code {|g| g.gen_basic disallow }.
          should == '@scanner.skip(/(?!\d)/) && true'
      end
    end
  end

  describe '#gen_assert' do

    context 'when nested' do
      it 'generates "false"' do
        nested_code {|g| g.gen_assert disallow }.should == 'false'
      end
    end

    context 'when top-level' do
      it 'generates "false"' do
        top_level_code {|g| g.gen_assert disallow }.should == 'false'
      end
    end
  end

  describe '#gen_disallow' do

    context 'when nested' do
      it 'generates nested negative lookahead code' do
        nested_code {|g| g.gen_disallow disallow }.
          should == '(@scanner.skip(/(?!\d)/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level negative lookahead code' do
        top_level_code {|g| g.gen_disallow disallow }.
          should == '@scanner.skip(/(?!\d)/) && true'
      end
    end
  end

  describe '#gen_dispatch_action' do

    let(:code) { NodeCode.new('Word', 'parsed') }

    context 'when nested' do
      it 'generates nested negative lookahead code with a dispatch action' do
        nested_code {|g| g.gen_dispatch_action disallow, code }.
          should == (<<-CODE).strip
begin
  @scanner.skip(/(?!\\d)/) &&
  Word.parsed([])
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level negative lookahead code with a dispatch action' do
        top_level_code {|g| g.gen_dispatch_action disallow, code }.
          should == (<<-CODE).strip
@scanner.skip(/(?!\\d)/) &&
Word.parsed([])
          CODE
      end
    end
  end

  describe '#gen_direct_action' do

    let(:code) { ActionCode.new(':t') }

    context 'when nested' do
      it 'generates nested negative lookahead code with a direct action' do
        nested_code {|g| g.gen_direct_action disallow, code }.
          should == (<<-CODE).strip
begin
  @scanner.skip(/(?!\\d)/) &&
  (:t)
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level negative lookahead code with a direct action' do
        top_level_code {|g| g.gen_direct_action disallow, code }.
          should == (<<-CODE).strip
@scanner.skip(/(?!\\d)/) &&
(:t)
          CODE
      end
    end
  end

  describe '#gen_token' do

    context 'when nested' do
      it 'generates nested negative lookahead and empty string string code' do
        nested_code {|g| g.gen_token disallow }.
          should == (<<-CODE).strip
begin
  @scanner.skip(/(?!\\d)/) &&
  ''
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top-level negative lookahead and empty string string code' do
        top_level_code {|g| g.gen_token disallow }.
          should == (<<-CODE).strip
@scanner.skip(/(?!\\d)/) &&
''
          CODE
      end
    end
  end

  describe '#gen_skip' do

    context 'when nested' do
      it 'generates nested negative lookahead code' do
        nested_code {|g| g.gen_skip disallow }.
          should == '(@scanner.skip(/(?!\d)/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level negative lookahead code' do
        top_level_code {|g| g.gen_skip disallow }.
          should == '@scanner.skip(/(?!\d)/) && true'
      end
    end
  end

  describe '#gen_intermediate' do
    it 'generates intermediate negative lookahead code' do
      nested_code {|g| g.gen_intermediate disallow }.
        should == '@scanner.skip(/(?!\d)/)'
    end
  end

  describe '#gen_intermediate_assert' do
    it 'generates "false"' do
      nested_code {|g| g.gen_intermediate_assert disallow }.should == 'false'
    end
  end

  describe '#gen_intermediate_disallow' do
    it 'generates intermediate negative lookahead code' do
      nested_code {|g| g.gen_intermediate_disallow disallow }.
        should == '@scanner.skip(/(?!\d)/)'
    end
  end

  describe '#gen_intermediate_skip' do
    it 'generates intermediate negative lookahead code' do
      nested_code {|g| g.gen_intermediate_skip disallow }.
        should == '@scanner.skip(/(?!\d)/)'
    end
  end

end
