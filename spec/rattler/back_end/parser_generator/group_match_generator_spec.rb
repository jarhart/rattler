require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::ParserGenerator
include Rattler::Parsers

describe GroupMatchGenerator do

  include ParserGeneratorSpecHelper

  let(:single_group) { GroupMatch[Match[/\s*(\w+)/], {:num_groups => 1}] }

  let(:multi_group) { GroupMatch[Match[/\s*(\w+)\s+(\w+)/], {:num_groups => 2}] }

  describe '#gen_basic' do

    context 'given a single-group match' do

      context 'when nested' do
        it 'generates nested regex group matching code returning the group' do
          nested_code {|g| g.gen_basic single_group }.
            should == (<<-CODE).strip
begin
  @scanner.skip(/\\s*(\\w+)/) &&
  @scanner[1]
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top-level regex group matching code returning the group' do
          top_level_code {|g| g.gen_basic single_group }.
            should == (<<-CODE).strip
@scanner.skip(/\\s*(\\w+)/) &&
@scanner[1]
            CODE
        end
      end
    end

    context 'given a multi-group match' do

      context 'when nested' do
        it 'generates nested regex matching code returning an array of groups' do
          nested_code {|g| g.gen_basic multi_group }.
            should == (<<-CODE).strip
begin
  @scanner.skip(/\\s*(\\w+)\\s+(\\w+)/) &&
  [@scanner[1], @scanner[2]]
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top-level regex matching code returning an array of groups' do
          top_level_code {|g| g.gen_basic multi_group }.
            should == (<<-CODE).strip
@scanner.skip(/\\s*(\\w+)\\s+(\\w+)/) &&
[@scanner[1], @scanner[2]]
            CODE
        end
      end
    end
  end

  describe '#gen_dispatch_action' do

    let(:code) { DispatchActionCode.new('Word', 'parsed') }

    context 'given a single-group match' do

      let(:match) { single_group }

      context 'when nested' do
        it 'generates nested regex group matching code with a dispatch action' do
          nested_code {|g| g.gen_dispatch_action match, code }.
            should == (<<-CODE).strip
begin
  @scanner.skip(/\\s*(\\w+)/) &&
  Word.parsed([@scanner[1]])
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top-level regex group matching code with a dispatch action' do
          top_level_code {|g| g.gen_dispatch_action match, code }.
            should == (<<-CODE).strip
@scanner.skip(/\\s*(\\w+)/) &&
Word.parsed([@scanner[1]])
            CODE
        end
      end
    end

    context 'given a multi-group match' do

      let(:match) { multi_group }

      context 'when nested' do
        it 'generates nested regex group matching code with a dispatch action' do
          nested_code {|g| g.gen_dispatch_action match, code }.
            should == (<<-CODE).strip
begin
  @scanner.skip(/\\s*(\\w+)\\s+(\\w+)/) &&
  Word.parsed([@scanner[1], @scanner[2]])
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top-level regex group matching code with a dispatch action' do
          top_level_code {|g| g.gen_dispatch_action match, code }.
            should == (<<-CODE).strip
@scanner.skip(/\\s*(\\w+)\\s+(\\w+)/) &&
Word.parsed([@scanner[1], @scanner[2]])
            CODE
        end
      end
    end
  end

  describe '#gen_direct_action' do

    context 'given a single-group match' do

      let(:match) { single_group }
      let(:code) { ActionCode.new('_.to_sym') }

      context 'when nested' do
        it 'generates nested regex matching code with a direct action' do
          nested_code {|g| g.gen_direct_action match, code }.
            should == (<<-CODE).strip
begin
  @scanner.skip(/\\s*(\\w+)/) &&
  (@scanner[1].to_sym)
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top level regex matching code with a direct action' do
          top_level_code {|g| g.gen_direct_action match, code }.
            should == (<<-CODE).strip
@scanner.skip(/\\s*(\\w+)/) &&
(@scanner[1].to_sym)
            CODE
        end
      end
    end

    context 'given a multi-group match' do

      let(:match) { multi_group }
      let(:code) { ActionCode.new('_.size') }

      context 'when nested' do
        it 'generates nested regex matching code with a direct action' do
          nested_code {|g| g.gen_direct_action match, code }.
            should == (<<-CODE).strip
begin
  @scanner.skip(/\\s*(\\w+)\\s+(\\w+)/) &&
  ([@scanner[1], @scanner[2]].size)
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top level regex matching code with a direct action' do
          top_level_code {|g| g.gen_direct_action match, code }.
            should == (<<-CODE).strip
@scanner.skip(/\\s*(\\w+)\\s+(\\w+)/) &&
([@scanner[1], @scanner[2]].size)
            CODE
        end
      end

    end
  end
end
