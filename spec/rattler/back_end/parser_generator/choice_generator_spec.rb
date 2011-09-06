require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::ParserGenerator
include Rattler::Parsers

describe ChoiceGenerator do

  include ParserGeneratorSpecHelper

  let(:choice) { Choice[Match[/[[:alpha:]]+/], Match[/[[:digit:]]+/]] }

  describe '#gen_basic' do

    context 'when nested' do
      it 'generates nested choice matching code' do
        nested_code(:choice_level => 2) {|g| g.gen_basic choice }.
          should == (<<-CODE).strip
begin
  @scanner.scan(/[[:alpha:]]+/) ||
  @scanner.scan(/[[:digit:]]+/)
end
        CODE
      end
    end

    context 'when top-level' do
      it 'generates top-level choice matching code' do
        top_level_code(:choice_level => 0) {|g| g.gen_basic choice }.
          should == (<<-CODE).strip
@scanner.scan(/[[:alpha:]]+/) ||
@scanner.scan(/[[:digit:]]+/)
        CODE
      end
    end
  end

  describe '#gen_assert' do

    context 'when nested' do
      it 'generates nested choice positive lookahead code' do
        nested_code(:choice_level => 2) {|g| g.gen_assert choice }.
          should == (<<-CODE).strip
(begin
  @scanner.skip(/(?=[[:alpha:]]+)/) ||
  @scanner.skip(/(?=[[:digit:]]+)/)
end && true)
        CODE
      end
    end

    context 'when top-level' do
      it 'generates top-level choice positive lookahead code' do
        top_level_code(:choice_level => 0) {|g| g.gen_assert choice }.
          should == (<<-CODE).strip
begin
  @scanner.skip(/(?=[[:alpha:]]+)/) ||
  @scanner.skip(/(?=[[:digit:]]+)/)
end && true
        CODE
      end
    end
  end

  describe '#gen_disallow' do

    context 'when nested' do
      it 'generates nested choice negative lookahead code' do
        nested_code(:choice_level => 2) {|g| g.gen_disallow choice }.
          should == (<<-CODE).strip
!begin
  @scanner.skip(/(?=[[:alpha:]]+)/) ||
  @scanner.skip(/(?=[[:digit:]]+)/)
end
        CODE
      end
    end

    context 'when top-level' do
      it 'generates top-level choice negative lookahead code' do
        top_level_code(:choice_level => 0) {|g| g.gen_disallow choice }.
          should == (<<-CODE).strip
!begin
  @scanner.skip(/(?=[[:alpha:]]+)/) ||
  @scanner.skip(/(?=[[:digit:]]+)/)
end
        CODE
      end
    end
  end

  describe '#gen_token' do

    context 'when nested' do
      it 'generates nested token choice matching code' do
        nested_code(:choice_level => 2) {|g| g.gen_token choice }.
          should == (<<-CODE).strip
begin
  @scanner.scan(/[[:alpha:]]+/) ||
  @scanner.scan(/[[:digit:]]+/)
end
        CODE
      end
    end

    context 'when top-level' do
      it 'generates top-level token choice matching code' do
        top_level_code(:choice_level => 0) {|g| g.gen_token choice }.
          should == (<<-CODE).strip
@scanner.scan(/[[:alpha:]]+/) ||
@scanner.scan(/[[:digit:]]+/)
        CODE
      end
    end
  end

  describe '#gen_skip' do

    context 'when nested' do
      it 'generates nested choice skipping code' do
        nested_code(:choice_level => 2) {|g| g.gen_skip choice }.
          should == (<<-CODE).strip
(begin
  @scanner.skip(/[[:alpha:]]+/) ||
  @scanner.skip(/[[:digit:]]+/)
end && true)
        CODE
      end
    end

    context 'when top-level' do
      it 'generates top-level choice skipping code' do
        top_level_code(:choice_level => 0) {|g| g.gen_skip choice }.
          should == (<<-CODE).strip
begin
  @scanner.skip(/[[:alpha:]]+/) ||
  @scanner.skip(/[[:digit:]]+/)
end && true
        CODE
      end
    end
  end

  describe '#gen_intermediate' do
    it 'generates nested choice matching code' do
      nested_code(:choice_level => 2) {|g| g.gen_intermediate choice }.
        should == (<<-CODE).strip
begin
  @scanner.scan(/[[:alpha:]]+/) ||
  @scanner.scan(/[[:digit:]]+/)
end
      CODE
    end
  end

  describe '#gen_intermediate_assert' do
    it 'generates intermediate choice positive lookahead code' do
      nested_code(:choice_level => 2) {|g| g.gen_intermediate_assert choice }.
        should == (<<-CODE).strip
begin
  @scanner.skip(/(?=[[:alpha:]]+)/) ||
  @scanner.skip(/(?=[[:digit:]]+)/)
end
      CODE
    end
  end

  describe '#gen_intermediate_disallow' do
    it 'generates intermediate choice negative lookahead code' do
      nested_code(:choice_level => 2) {|g| g.gen_intermediate_disallow choice }.
        should == (<<-CODE).strip
!begin
  @scanner.skip(/(?=[[:alpha:]]+)/) ||
  @scanner.skip(/(?=[[:digit:]]+)/)
end
      CODE
    end
  end

  describe '#gen_intermediate_skip' do
    it 'generates intermediate choice skipping code' do
      nested_code(:choice_level => 2) {|g| g.gen_intermediate_skip choice }.
        should == (<<-CODE).strip
begin
  @scanner.skip(/[[:alpha:]]+/) ||
  @scanner.skip(/[[:digit:]]+/)
end
      CODE
    end
  end

end
