require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Compiler::ParserGenerator
include Rattler::Parsers

describe SuperGenerator do

  include ParserGeneratorSpecHelper

  let(:parser) { Super[:foo] }

  describe '#gen_basic' do
    it 'generates "super"' do
      nested_code {|g| g.gen_basic parser }.should == 'super'
    end
  end

  describe '#gen_assert' do

    context 'when nested' do
      it 'generates nested "assert super" code' do
        nested_code {|g| g.gen_assert parser }.should == (<<-CODE).strip
begin
  p = @scanner.pos
  r = (super && true)
  @scanner.pos = p
  r
end
        CODE
      end
    end

    context 'when top level' do
      it 'generates top-level "assert super" code' do
        top_level_code {|g| g.gen_assert parser }.should == (<<-CODE).strip
p = @scanner.pos
r = (super && true)
@scanner.pos = p
r
        CODE
      end
    end
  end

  describe '#gen_disallow' do

    context 'when nested' do
      it 'generates nested "disallow super" code' do
        nested_code {|g| g.gen_disallow parser }.should == (<<-CODE).strip
begin
  p = @scanner.pos
  r = !super
  @scanner.pos = p
  r
end
        CODE
      end
    end

    context 'when top level' do
      it 'generates top-level "disallow super" code' do
        top_level_code {|g| g.gen_disallow parser }.should == (<<-CODE).strip
p = @scanner.pos
r = !super
@scanner.pos = p
r
        CODE
      end
    end
  end

  describe '#gen_token' do
    it 'generates "super.to_s"' do
      nested_code {|g| g.gen_token parser }.should == 'super.to_s'
    end
  end

  describe '#gen_skip' do

    context 'when nested' do
      it 'generates "(super && true)"' do
        nested_code {|g| g.gen_skip parser }.should == '(super && true)'
      end
    end

    context 'when top level' do
      it 'generates "super && true"' do
        top_level_code {|g| g.gen_skip parser }.should == 'super && true'
      end
    end
  end

end
