require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::ParserGenerator
include Rattler::Parsers

describe SequenceGenerator do

  include ParserGeneratorSpecHelper

  let(:sequence) { Sequence[Match[/[[:alpha:]]+/], Match[/[[:digit:]]+/]] }

  describe '#gen_basic' do

    context 'when nested' do
      it 'generates nested sequence matching code' do
        nested_code(:sequence_level => 2) {|g| g.gen_basic sequence }.
          should == (<<-CODE).strip
begin
  p2 = @scanner.pos
  begin
    (r2_0 = @scanner.scan(/[[:alpha:]]+/)) &&
    (r2_1 = @scanner.scan(/[[:digit:]]+/)) &&
    [r2_0, r2_1]
  end || begin
    @scanner.pos = p2
    false
  end
end
        CODE
      end
    end

    context 'when top-level' do
      it 'generates top-level sequence matching code' do
        top_level_code(:sequence_level => 0) {|g| g.gen_basic sequence }.
          should == (<<-CODE).strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/[[:alpha:]]+/)) &&
  (r0_1 = @scanner.scan(/[[:digit:]]+/)) &&
  [r0_0, r0_1]
end || begin
  @scanner.pos = p0
  false
end
        CODE
      end
    end
  end

  describe '#gen_assert' do

    context 'when nested' do
      it 'generates nested sequence positive lookahead code' do
        nested_code(:sequence_level => 2) {|g| g.gen_assert sequence }.
          should == (<<-CODE).strip
begin
  p2 = @scanner.pos
  r = begin
    @scanner.skip(/[[:alpha:]]+/) &&
    @scanner.skip(/[[:digit:]]+/) &&
    true
  end
  @scanner.pos = p2
  r
end
        CODE
      end
    end

    context 'when top-level' do
      it 'generates top-level sequence positive lookahead code' do
        top_level_code(:sequence_level => 0) {|g| g.gen_assert sequence }.
          should == (<<-CODE).strip
p0 = @scanner.pos
r = begin
  @scanner.skip(/[[:alpha:]]+/) &&
  @scanner.skip(/[[:digit:]]+/) &&
  true
end
@scanner.pos = p0
r
        CODE
      end
    end
  end

  describe '#gen_disallow' do

    context 'when nested' do
      it 'generates nested sequence negative lookahead code' do
        nested_code(:sequence_level => 2) {|g| g.gen_disallow sequence }.
          should == (<<-CODE).strip
begin
  p2 = @scanner.pos
  r = !begin
    @scanner.skip(/[[:alpha:]]+/) &&
    @scanner.skip(/[[:digit:]]+/)
  end
  @scanner.pos = p2
  r
end
        CODE
      end
    end

    context 'when top-level' do
      it 'generates top-level sequence negative lookahead code' do
        top_level_code(:sequence_level => 0) {|g| g.gen_disallow sequence }.
          should == (<<-CODE).strip
p0 = @scanner.pos
r = !begin
  @scanner.skip(/[[:alpha:]]+/) &&
  @scanner.skip(/[[:digit:]]+/)
end
@scanner.pos = p0
r
        CODE
      end
    end
  end

  describe '#gen_dispatch_action' do

    let(:code) { DispatchActionCode.new('Atom', 'parsed') }

    context 'when nested' do
      it 'generates nested sequence matching code with a dispatch action' do
        nested_code(:sequence_level => 2) {|g| g.gen_dispatch_action sequence, code }.
          should == (<<-CODE).strip
begin
  p2 = @scanner.pos
  begin
    (r2_0 = @scanner.scan(/[[:alpha:]]+/)) &&
    (r2_1 = @scanner.scan(/[[:digit:]]+/)) &&
    Atom.parsed([r2_0, r2_1])
  end || begin
    @scanner.pos = p2
    false
  end
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top-level sequence matching code with a dispatch action' do
        top_level_code(:sequence_level => 0) {|g| g.gen_dispatch_action sequence, code }.
          should == (<<-CODE).strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/[[:alpha:]]+/)) &&
  (r0_1 = @scanner.scan(/[[:digit:]]+/)) &&
  Atom.parsed([r0_0, r0_1])
end || begin
  @scanner.pos = p0
  false
end
          CODE
      end
    end
  end

  describe '#gen_direct_action' do

    let(:code) { ActionCode.new('|a,b| a + b') }

    context 'when nested' do
      it 'generates nested sequence matching code with a direct action' do
        nested_code(:sequence_level => 2) {|g| g.gen_direct_action sequence, code }.
          should == (<<-CODE).strip
begin
  p2 = @scanner.pos
  begin
    (r2_0 = @scanner.scan(/[[:alpha:]]+/)) &&
    (r2_1 = @scanner.scan(/[[:digit:]]+/)) &&
    (r2_0 + r2_1)
  end || begin
    @scanner.pos = p2
    false
  end
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates nested sequence matching code with a direct action' do
        top_level_code(:sequence_level => 0) {|g| g.gen_direct_action sequence, code }.
          should == (<<-CODE).strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/[[:alpha:]]+/)) &&
  (r0_1 = @scanner.scan(/[[:digit:]]+/)) &&
  (r0_0 + r0_1)
end || begin
  @scanner.pos = p0
  false
end
          CODE
      end
    end
  end

  describe '#gen_skip' do

    context 'when nested' do
      it 'generates nested token sequence matching code' do
        nested_code(:sequence_level => 2) {|g| g.gen_skip sequence }.
          should == (<<-CODE).strip
begin
  p2 = @scanner.pos
  begin
    @scanner.skip(/[[:alpha:]]+/) &&
    @scanner.skip(/[[:digit:]]+/) &&
    true
  end || begin
    @scanner.pos = p2
    false
  end
end
        CODE
      end
    end

    context 'when top-level' do
      it 'generates top-level token sequence matching code' do
        top_level_code(:sequence_level => 0) {|g| g.gen_skip sequence }.
          should == (<<-CODE).strip
p0 = @scanner.pos
begin
  @scanner.skip(/[[:alpha:]]+/) &&
  @scanner.skip(/[[:digit:]]+/) &&
  true
end || begin
  @scanner.pos = p0
  false
end
        CODE
      end
    end
  end

  describe '#gen_token' do

    context 'when nested' do
      it 'generates nested token sequence matching code' do
        nested_code(:sequence_level => 2) {|g| g.gen_token sequence }.
          should == (<<-CODE).strip
begin
  p2 = @scanner.pos
  begin
    @scanner.skip(/[[:alpha:]]+/) &&
    @scanner.skip(/[[:digit:]]+/) &&
    @scanner.string[p2...(@scanner.pos)]
  end || begin
    @scanner.pos = p2
    false
  end
end
        CODE
      end
    end

    context 'when top-level' do
      it 'generates top-level token sequence matching code' do
        top_level_code(:sequence_level => 0) {|g| g.gen_token sequence }.
          should == (<<-CODE).strip
p0 = @scanner.pos
begin
  @scanner.skip(/[[:alpha:]]+/) &&
  @scanner.skip(/[[:digit:]]+/) &&
  @scanner.string[p0...(@scanner.pos)]
end || begin
  @scanner.pos = p0
  false
end
        CODE
      end
    end
  end

  describe '#gen_intermediate' do
    it 'generates nested sequence matching code' do
      nested_code(:sequence_level => 2) {|g| g.gen_intermediate sequence }.
        should == (<<-CODE).strip
begin
  p2 = @scanner.pos
  begin
    (r2_0 = @scanner.scan(/[[:alpha:]]+/)) &&
    (r2_1 = @scanner.scan(/[[:digit:]]+/)) &&
    [r2_0, r2_1]
  end || begin
    @scanner.pos = p2
    false
  end
end
      CODE
    end
  end

  describe '#gen_intermediate_assert' do
    it 'generates nested sequence positive lookahead code' do
      nested_code(:sequence_level => 2) {|g| g.gen_intermediate_assert sequence }.
        should == (<<-CODE).strip
begin
  p2 = @scanner.pos
  r = begin
    @scanner.skip(/[[:alpha:]]+/) &&
    @scanner.skip(/[[:digit:]]+/) &&
    true
  end
  @scanner.pos = p2
  r
end
      CODE
    end
  end

  describe '#gen_intermediate_disallow' do
    it 'generates nested sequence negative lookahead code' do
      nested_code(:sequence_level => 2) {|g| g.gen_intermediate_disallow sequence }.
        should == (<<-CODE).strip
begin
  p2 = @scanner.pos
  r = !begin
    @scanner.skip(/[[:alpha:]]+/) &&
    @scanner.skip(/[[:digit:]]+/)
  end
  @scanner.pos = p2
  r
end
      CODE
    end
  end

  describe '#gen_intermediate_skip' do
    it 'generates nested sequence skipping code' do
      nested_code(:sequence_level => 2) {|g| g.gen_intermediate_skip sequence }.
        should == (<<-CODE).strip
begin
  p2 = @scanner.pos
  begin
    @scanner.skip(/[[:alpha:]]+/) &&
    @scanner.skip(/[[:digit:]]+/) &&
    true
  end || begin
    @scanner.pos = p2
    false
  end
end
      CODE
    end
  end

end
