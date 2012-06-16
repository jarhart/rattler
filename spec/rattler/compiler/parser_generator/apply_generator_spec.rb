require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Compiler::ParserGenerator
include Rattler::Parsers

describe ApplyGenerator do

  include ParserGeneratorSpecHelper

  let(:apply) { Apply[:foo] }

  describe '#gen_basic' do

    context 'when nested' do
      it 'generates basic apply-rule code' do
        nested_code {|g| g.gen_basic apply }.
          should == 'match(:foo)'
      end
    end

    context 'when top-level' do
      it 'generates basic apply-rule code' do
        top_level_code {|g| g.gen_basic apply }.
          should == 'match(:foo)'
      end
    end
  end

  describe '#gen_assert' do

    context 'when nested' do
      it 'generates nested rule positive lookahead code' do
        nested_code {|g| g.gen_assert apply }.
          should == (<<-CODE).strip
begin
  p = @scanner.pos
  r = (match(:foo) && true)
  @scanner.pos = p
  r
end
        CODE
      end
    end

    context 'when top-level' do
      it 'generates top level rule positive lookahead code' do
        top_level_code {|g| g.gen_assert apply }.
          should == (<<-CODE).strip
p = @scanner.pos
r = (match(:foo) && true)
@scanner.pos = p
r
        CODE
      end
    end
  end

  describe '#gen_disallow' do

    context 'when nested' do
      it 'generates nested rule negative lookahead code' do
        nested_code {|g| g.gen_disallow apply }.
          should == (<<-CODE).strip
begin
  p = @scanner.pos
  r = !match(:foo)
  @scanner.pos = p
  r
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level rule negative lookahead code' do
        top_level_code {|g| g.gen_disallow apply }.
          should == (<<-CODE).strip
p = @scanner.pos
r = !match(:foo)
@scanner.pos = p
r
          CODE
      end
    end
  end

  describe '#gen_token' do

    context 'when nested' do
      it 'generates nested apply-rule code returning the matched string' do
        nested_code {|g| g.gen_token apply }.
          should == (<<-CODE).strip
begin
  tp = @scanner.pos
  match(:foo) &&
  @scanner.string[tp...(@scanner.pos)]
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level apply-rule code returning the matched string' do
        top_level_code {|g| g.gen_token apply }.
          should == (<<-CODE).strip
tp = @scanner.pos
match(:foo) &&
@scanner.string[tp...(@scanner.pos)]
          CODE
      end
    end
  end

  describe '#gen_skip' do

    context 'when nested' do
      it 'generates nested rule skipping code' do
        nested_code {|g| g.gen_skip apply }.
          should == '(match(:foo) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level rule skipping code' do
        top_level_code {|g| g.gen_skip apply }.
          should == 'match(:foo) && true'
      end
    end
  end

  describe '#gen_intermediate' do
    it 'generates basic apply-rule code' do
      nested_code {|g| g.gen_intermediate apply }.
        should == 'match(:foo)'
    end
  end

  describe '#gen_intermediate_assert' do
    it 'generates nested rule positive lookahead code' do
      nested_code {|g| g.gen_intermediate_assert apply }.
        should == (<<-CODE).strip
begin
  p = @scanner.pos
  r = (match(:foo) && true)
  @scanner.pos = p
  r
end
        CODE
    end
  end

  describe '#gen_intermediate_disallow' do
    it 'generates nested rule negative lookahead code' do
      nested_code {|g| g.gen_intermediate_disallow apply }.
        should == (<<-CODE).strip
begin
  p = @scanner.pos
  r = !match(:foo)
  @scanner.pos = p
  r
end
        CODE
    end
  end

  describe '#gen_intermediate_skip' do
    it 'generates basic apply-rule code' do
      nested_code {|g| g.gen_intermediate_skip apply }.
        should == 'match(:foo)'
    end
  end

end
