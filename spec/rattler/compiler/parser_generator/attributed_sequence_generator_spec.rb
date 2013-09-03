require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Compiler::ParserGenerator
include Rattler::Parsers

describe AttributedSequenceGenerator do

  include ParserGeneratorSpecHelper
  include Rattler::Runtime

  let(:sequence) { AttributedSequence[*children] }

  describe '#gen_basic' do

    context 'given a sequence with a single capture and a semantic action' do

      let(:children) { [Match[/\w+/], action] }

      context 'when the action uses a paramter' do

        let(:action) { SemanticAction['|s| "<#{s}>"'] }

        it 'generates code that binds the capture to the parameter and returns the result' do
          top_level_code(:sequence_level => 0) {|g| g.gen_basic sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\w+/)) &&
  ("<#{r0_0}>")
end || begin
  @scanner.pos = p0
  false
end
          CODE
        end
      end

      context 'when the action uses a "_"' do

        let(:action) { SemanticAction['"<#{_}>"'] }

        it 'generates code that binds the capture to "_" and returns the result' do
          top_level_code(:sequence_level => 0) {|g| g.gen_basic sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\w+/)) &&
  ("<#{r0_0}>")
end || begin
  @scanner.pos = p0
  false
end
          CODE
        end
      end
    end

    context 'given a sequence with a single capture and a node action' do

      let(:children) { [Match[/\w+/], NodeAction['Expr']] }

      it 'generates code that returns a new node with the capture' do
          top_level_code(:sequence_level => 0) {|g| g.gen_basic sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\w+/)) &&
  Expr.parsed([r0_0])
end || begin
  @scanner.pos = p0
  false
end
          CODE
      end
    end

    context 'given a sequence with an undecidable capture and a node action' do

      let(:children) { [Apply[:a], NodeAction['Expr']] }

      it 'generates code that returns a new node using select_captures' do
          top_level_code(:sequence_level => 0) {|g| g.gen_basic sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = match_a) &&
  Expr.parsed(select_captures([r0_0]))
end || begin
  @scanner.pos = p0
  false
end
          CODE
      end
    end

    context 'given a sequence with multiple captures and a semantic action' do

      let(:children) { [Match[/\d+/], Skip[Match[/\s+/]], Match[/\d+/], action] }

      context 'when the action uses parameters' do

        let(:action) { SemanticAction['|a,b| b + a'] }

        it 'generates code that binds the captures to the parameter and returns the result' do
          top_level_code(:sequence_level => 0) {|g| g.gen_basic sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  (r0_1 + r0_0)
end || begin
  @scanner.pos = p0
  false
end
          CODE
        end
      end

      context 'when the action uses "_"' do

        let(:action) { SemanticAction['_ * 2'] }

        it 'generates code that binds the array of captures to the parameter and returns the result' do
          top_level_code(:sequence_level => 0) {|g| g.gen_basic sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  ([r0_0, r0_1] * 2)
end || begin
  @scanner.pos = p0
  false
end
          CODE
        end
      end
    end

    context 'given a sequence with multiple captures and a node action' do

      let :children do
        [Match[/\d+/], Skip[Match[/\s+/]], Match[/\d+/], NodeAction['Nums']]
      end

      it 'generates code that returns a new node with the captures' do
        top_level_code(:sequence_level => 0) {|g| g.gen_basic sequence }.
        should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  Nums.parsed([r0_0, r0_1])
end || begin
  @scanner.pos = p0
  false
end
        CODE
      end
    end

    context 'given a sequence with labeled captures and a semantic action' do

      let(:children) { [
        Label[:x, Match[/\d+/]],
        Skip[Match[/\s+/]],
        Label[:y, Match[/\d+/]],
        SemanticAction['y + x']
      ] }

      it 'generates code that binds the labeled captures to the parameter and returns the result' do
        top_level_code(:sequence_level => 0) {|g| g.gen_basic sequence }.
        should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  (r0_1 + r0_0)
end || begin
  @scanner.pos = p0
  false
end
        CODE
      end
    end

    context 'given a sequence with labeled captures and a node action' do

      let(:children) { [
        Label[:x, Match[/\d+/]],
        Skip[Match[/\s+/]],
        Match[/\d+/],
        NodeAction['Nums']
      ] }

      it 'generates code that returns a new node with the bindings as the :labeled attribute' do
        top_level_code(:sequence_level => 0) {|g| g.gen_basic sequence }.
        should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  Nums.parsed([r0_0, r0_1], :labeled => {:x => r0_0})
end || begin
  @scanner.pos = p0
  false
end
        CODE
      end
    end
  end

  describe '#gen_assert' do

    context 'given a sequence with a single capture and a semantic action' do

      let(:children) { [Match[/\w+/], action] }

      context 'when the action uses a paramter' do

        let(:action) { SemanticAction['|s| "<#{s}>"'] }

        it 'generates code that binds the capture to the parameter and asserts the result' do
          top_level_code(:sequence_level => 0) {|g| g.gen_assert sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
r = begin
  (r0_0 = @scanner.scan(/\w+/)) &&
  ("<#{r0_0}>") &&
  true
end
@scanner.pos = p0
r
          CODE
        end
      end

      context 'when the action uses a "_"' do

        let(:action) { SemanticAction['"<#{_}>"'] }

        it 'generates code that binds the capture to "_" and asserts the result' do
          top_level_code(:sequence_level => 0) {|g| g.gen_assert sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
r = begin
  (r0_0 = @scanner.scan(/\w+/)) &&
  ("<#{r0_0}>") &&
  true
end
@scanner.pos = p0
r
          CODE
        end
      end
    end

    context 'given a sequence with multiple captures and a semantic action' do

      let(:children) { [Match[/\d+/], Skip[Match[/\s+/]], Match[/\d+/], action] }

      context 'when the action uses parameters' do

        let(:action) { SemanticAction['|a,b| b + a'] }

        it 'generates code that binds the captures to the parameter and asserts the result' do
          top_level_code(:sequence_level => 0) {|g| g.gen_assert sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
r = begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  (r0_1 + r0_0) &&
  true
end
@scanner.pos = p0
r
          CODE
        end
      end

      context 'when the action uses "_"' do

        let(:action) { SemanticAction['_ * 2'] }

        it 'generates code that binds the array of captures to the parameter and asserts the result' do
          top_level_code(:sequence_level => 0) {|g| g.gen_assert sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
r = begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  ([r0_0, r0_1] * 2) &&
  true
end
@scanner.pos = p0
r
          CODE
        end
      end
    end

    context 'given a sequence with labeled captures and a semantic action' do

      let(:children) { [
        Label[:x, Match[/\d+/]],
        Skip[Match[/\s+/]],
        Label[:y, Match[/\d+/]],
        SemanticAction['y + x']
      ] }

      it 'generates code that binds the labeled captures to the parameter and asserts the result' do
        top_level_code(:sequence_level => 0) {|g| g.gen_assert sequence }.
        should == (<<-'CODE').strip
p0 = @scanner.pos
r = begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  (r0_1 + r0_0) &&
  true
end
@scanner.pos = p0
r
        CODE
      end
    end
  end

  describe '#gen_disallow' do

    context 'given a sequence with a single capture and a semantic action' do

      let(:children) { [Match[/\w+/], action] }

      context 'when the action uses a paramter' do

        let(:action) { SemanticAction['|s| "<#{s}>"'] }

        it 'generates code that binds the capture to the parameter and disallows the result' do
          top_level_code(:sequence_level => 0) {|g| g.gen_disallow sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
r = !begin
  (r0_0 = @scanner.scan(/\w+/)) &&
  ("<#{r0_0}>")
end
@scanner.pos = p0
r
          CODE
        end
      end

      context 'when the action uses a "_"' do

        let(:action) { SemanticAction['"<#{_}>"'] }

        it 'generates code that binds the capture to "_" and disallows the result' do
          top_level_code(:sequence_level => 0) {|g| g.gen_disallow sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
r = !begin
  (r0_0 = @scanner.scan(/\w+/)) &&
  ("<#{r0_0}>")
end
@scanner.pos = p0
r
          CODE
        end
      end
    end

    context 'given a sequence with multiple captures and a semantic action' do

      let(:children) { [Match[/\d+/], Skip[Match[/\s+/]], Match[/\d+/], action] }

      context 'when the action uses parameters' do

        let(:action) { SemanticAction['|a,b| b + a'] }

        it 'generates code that binds the captures to the parameter and disallows the result' do
          top_level_code(:sequence_level => 0) {|g| g.gen_disallow sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
r = !begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  (r0_1 + r0_0)
end
@scanner.pos = p0
r
          CODE
        end
      end

      context 'when the action uses "_"' do

        let(:action) { SemanticAction['_ * 2'] }

        it 'generates code that binds the array of captures to the parameter and disallows the result' do
          top_level_code(:sequence_level => 0) {|g| g.gen_disallow sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
r = !begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  ([r0_0, r0_1] * 2)
end
@scanner.pos = p0
r
          CODE
        end
      end
    end

    context 'given a sequence with labeled captures and a semantic action' do

      let(:children) { [
        Label[:x, Match[/\d+/]],
        Skip[Match[/\s+/]],
        Label[:y, Match[/\d+/]],
        SemanticAction['y + x']
      ] }

      it 'generates code that binds the labeled captures to the parameter and disallows the result' do
        top_level_code(:sequence_level => 0) {|g| g.gen_disallow sequence }.
        should == (<<-'CODE').strip
p0 = @scanner.pos
r = !begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  (r0_1 + r0_0)
end
@scanner.pos = p0
r
        CODE
      end
    end
  end

  describe '#gen_token' do

    context 'given a sequence with a single capture and a semantic action' do

      let(:children) { [Match[/\w+/], action] }

      context 'when the action uses a paramter' do

        let(:action) { SemanticAction['|s| "<#{s}>"'] }

        it 'generates code that binds the capture to the parameter and returns the matched string' do
          top_level_code(:sequence_level => 0) {|g| g.gen_token sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\w+/)) &&
  ("<#{r0_0}>") &&
  @scanner.string[p0...(@scanner.pos)]
end || begin
  @scanner.pos = p0
  false
end
          CODE
        end
      end

      context 'when the action uses a "_"' do

        let(:action) { SemanticAction['"<#{_}>"'] }

        it 'generates code that binds the capture to "_" and returns the matched string' do
          top_level_code(:sequence_level => 0) {|g| g.gen_token sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\w+/)) &&
  ("<#{r0_0}>") &&
  @scanner.string[p0...(@scanner.pos)]
end || begin
  @scanner.pos = p0
  false
end
          CODE
        end
      end
    end

    context 'given a sequence with multiple captures and a semantic action' do

      let(:children) { [Match[/\d+/], Skip[Match[/\s+/]], Match[/\d+/], action] }

      context 'when the action uses parameters' do

        let(:action) { SemanticAction['|a,b| b + a'] }

        it 'generates code that binds the captures to the parameter and returns the matched string' do
          top_level_code(:sequence_level => 0) {|g| g.gen_token sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  (r0_1 + r0_0) &&
  @scanner.string[p0...(@scanner.pos)]
end || begin
  @scanner.pos = p0
  false
end
          CODE
        end
      end

      context 'when the action uses "_"' do

        let(:action) { SemanticAction['_ * 2'] }

        it 'generates code that binds the array of captures to the parameter and returns the matched string' do
          top_level_code(:sequence_level => 0) {|g| g.gen_token sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  ([r0_0, r0_1] * 2) &&
  @scanner.string[p0...(@scanner.pos)]
end || begin
  @scanner.pos = p0
  false
end
          CODE
        end
      end
    end

    context 'given a sequence with labeled captures and a semantic action' do

      let(:children) { [
        Label[:x, Match[/\d+/]],
        Skip[Match[/\s+/]],
        Label[:y, Match[/\d+/]],
        SemanticAction['y + x']
      ] }

      it 'generates code that binds the labeled captures to the parameter and returns the matched string' do
        top_level_code(:sequence_level => 0) {|g| g.gen_token sequence }.
        should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  (r0_1 + r0_0) &&
  @scanner.string[p0...(@scanner.pos)]
end || begin
  @scanner.pos = p0
  false
end
        CODE
      end
    end
  end

  describe '#gen_skip' do

    context 'given a sequence with a single capture and a semantic action' do

      let(:children) { [Match[/\w+/], action] }

      context 'when the action uses a paramter' do

        let(:action) { SemanticAction['|s| "<#{s}>"'] }

        it 'generates code that binds the capture to the parameter and skips the result' do
          top_level_code(:sequence_level => 0) {|g| g.gen_skip sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\w+/)) &&
  ("<#{r0_0}>") &&
  true
end || begin
  @scanner.pos = p0
  false
end
          CODE
        end
      end

      context 'when the action uses a "_"' do

        let(:action) { SemanticAction['"<#{_}>"'] }

        it 'generates code that binds the capture to "_" and skips the result' do
          top_level_code(:sequence_level => 0) {|g| g.gen_skip sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\w+/)) &&
  ("<#{r0_0}>") &&
  true
end || begin
  @scanner.pos = p0
  false
end
          CODE
        end
      end
    end

    context 'given a sequence with multiple captures and a semantic action' do

      let(:children) { [Match[/\d+/], Skip[Match[/\s+/]], Match[/\d+/], action] }

      context 'when the action uses parameters' do

        let(:action) { SemanticAction['|a,b| b + a'] }

        it 'generates code that binds the captures to the parameter and skips the result' do
          top_level_code(:sequence_level => 0) {|g| g.gen_skip sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  (r0_1 + r0_0) &&
  true
end || begin
  @scanner.pos = p0
  false
end
          CODE
        end
      end

      context 'when the action uses "_"' do

        let(:action) { SemanticAction['_ * 2'] }

        it 'generates code that binds the array of captures to the parameter and skips the result' do
          top_level_code(:sequence_level => 0) {|g| g.gen_skip sequence }.
          should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  ([r0_0, r0_1] * 2) &&
  true
end || begin
  @scanner.pos = p0
  false
end
          CODE
        end
      end
    end

    context 'given a sequence with labeled captures and a semantic action' do

      let(:children) { [
        Label[:x, Match[/\d+/]],
        Skip[Match[/\s+/]],
        Label[:y, Match[/\d+/]],
        SemanticAction['y + x']
      ] }

      it 'generates code that binds the labeled captures to the parameter and skips the result' do
        top_level_code(:sequence_level => 0) {|g| g.gen_skip sequence }.
        should == (<<-'CODE').strip
p0 = @scanner.pos
begin
  (r0_0 = @scanner.scan(/\d+/)) &&
  @scanner.skip(/\s+/) &&
  (r0_1 = @scanner.scan(/\d+/)) &&
  (r0_1 + r0_0) &&
  true
end || begin
  @scanner.pos = p0
  false
end
        CODE
      end
    end
  end
end
