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

    context 'given a sequence with a single capture and a semantic action' do

      let(:sequence) { Sequence[Match[/\w+/], action] }

      context 'when the action uses a parameter' do

        let(:action) { SemanticAction['|s| "<#{s}>"'] }

        it 'generates code that binds the capture to the parameter' do
          top_level_code(:sequence_level => 0) {|g| g.gen_basic sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\w+/)) &&
  (r0_1 = ("<#{r0_0}>")) &&
  [r0_0, r0_1]
end || begin
  @scanner.pos = p0
  false
end
          CODE
        end
      end

      context 'when the action uses a "_"' do

        let(:action) { SemanticAction['"<#{_}>"'] }

        it 'generates code that binds the capture to "_"' do
          top_level_code(:sequence_level => 0) {|g| g.gen_basic sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\w+/)) &&
  (r0_1 = ("<#{r0_0}>")) &&
  [r0_0, r0_1]
end || begin
  @scanner.pos = p0
  false
end
          CODE
        end
      end
    end

    context 'given a sequence with multiple captures and a semantic action' do

      let(:sequence) { Sequence[Match[/\d+/], Skip[Match[/\s+/]], Match[/\d+/], action] }

      context 'when the action uses parameters' do

        let(:action) { SemanticAction['|a,b| b + a'] }

        it 'generates code that binds the captures to the parameter' do
          top_level_code(:sequence_level => 0) {|g| g.gen_basic sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  (r0_2 = (r0_1 + r0_0)) &&
  [r0_0, r0_1, r0_2]
end || begin
  @scanner.pos = p0
  false
end
          CODE
        end
      end

      context 'when the action uses "_"' do

        let(:action) { SemanticAction['_ * 2'] }

        it 'generates code that binds the array of captures to the parameter' do
          top_level_code(:sequence_level => 0) {|g| g.gen_basic sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  (r0_2 = ([r0_0, r0_1] * 2)) &&
  [r0_0, r0_1, r0_2]
end || begin
  @scanner.pos = p0
  false
end
          CODE
        end
      end
    end

    context 'given a sequence with labeled captures and a semantic action' do

      let(:sequence) { Sequence[
        Label[:x, Match[/\d+/]],
        Skip[Match[/\s+/]],
        Label[:y, Match[/\d+/]],
        SemanticAction['y + x']
      ] }

      it 'generates code that binds the labeled captures to the parameter' do
        top_level_code(:sequence_level => 0) {|g| g.gen_basic sequence }.
        should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  (r0_2 = (r0_1 + r0_0)) &&
  [r0_0, r0_1, r0_2]
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

    let(:code) { NodeCode.new('Atom', 'parsed') }

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
