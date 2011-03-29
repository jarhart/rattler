require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::ParserGenerator
include Rattler::Parsers

describe OneOrMoreGenerator do

  include ParserGeneratorSpecHelper

  let(:one_or_more) { OneOrMore[Match[/w+/]] }

  describe '#gen_basic' do

    let :one_or_more do
      OneOrMore[Choice[Match[/[[:alpha:]]/], Match[/[[:digit:]]/]]]
    end

    context 'when nested' do
      it 'generates nested one-or-more matching code' do
        nested_code {|g| g.gen_basic one_or_more }.
          should == (<<-CODE).strip
begin
  a = []
  while r = begin
    @scanner.scan(/[[:alpha:]]/) ||
    @scanner.scan(/[[:digit:]]/)
  end
    a << r
  end
  a unless a.empty?
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level one-or-more matching code' do
        top_level_code {|g| g.gen_basic one_or_more }.
          should == (<<-CODE).strip
a = []
while r = begin
  @scanner.scan(/[[:alpha:]]/) ||
  @scanner.scan(/[[:digit:]]/)
end
  a << r
end
a unless a.empty?
          CODE
      end
    end
  end

  describe '#gen_assert' do

    context 'when nested' do
      it 'generates nested one-or-more positive lookahead code' do
        nested_code {|g| g.gen_assert one_or_more }.
          should == '(@scanner.skip(/(?=w+)/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level one-or-more positive lookahead code' do
        top_level_code {|g| g.gen_assert one_or_more }.
          should == '@scanner.skip(/(?=w+)/) && true'
      end
    end
  end

  describe '#gen_disallow' do

    context 'when nested' do
      it 'generates nested one-or-more negative lookahead code' do
        nested_code {|g| g.gen_disallow one_or_more }.
          should == '(@scanner.skip(/(?!w+)/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level one-or-more negative lookahead code' do
        top_level_code {|g| g.gen_disallow one_or_more }.
          should == '@scanner.skip(/(?!w+)/) && true'
      end
    end
  end

  describe '#gen_dispatch_action' do

    let(:code) { NodeCode.new('Word', 'parsed') }

    context 'when nested' do
      it 'generates nested one-or-more matching code with a dispatch action' do
        nested_code {|g| g.gen_dispatch_action one_or_more, code }.
          should == (<<-CODE).strip
begin
  a = []
  while r = @scanner.scan(/w+/)
    a << r
  end
  Word.parsed(select_captures(a)) unless a.empty?
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level one-or-more matching code with a dispatch action' do
        top_level_code {|g| g.gen_dispatch_action one_or_more, code }.
          should == (<<-CODE).strip
a = []
while r = @scanner.scan(/w+/)
  a << r
end
Word.parsed(select_captures(a)) unless a.empty?
          CODE
      end
    end
  end

  describe '#gen_direct_action' do

    let(:code) { ActionCode.new('|_| _.size') }

    context 'when nested' do
      it 'generates nested one-or-more matching code with a direct action' do
        nested_code {|g| g.gen_direct_action one_or_more, code }.
          should == (<<-CODE).strip
begin
  a = []
  while r = @scanner.scan(/w+/)
    a << r
  end
  (select_captures(a).size) unless a.empty?
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level one-or-more matching code with a direct action' do
        top_level_code {|g| g.gen_direct_action one_or_more, code }.
          should == (<<-CODE).strip
a = []
while r = @scanner.scan(/w+/)
  a << r
end
(select_captures(a).size) unless a.empty?
          CODE
      end
    end
  end

  describe '#gen_token' do

    context 'when nested' do
      it 'generates nested one-or-more matching code' do
        nested_code {|g| g.gen_token one_or_more }.
          should == (<<-CODE).strip
begin
  a = []
  while r = @scanner.scan(/w+/)
    a << r
  end
  a.join unless a.empty?
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level one-or-more matching code' do
        top_level_code {|g| g.gen_token one_or_more }.
          should == (<<-CODE).strip
a = []
while r = @scanner.scan(/w+/)
  a << r
end
a.join unless a.empty?
          CODE
      end
    end
  end

  describe '#gen_skip' do

    context 'when nested' do
      it 'generates nested one-or-more skipping code' do
        nested_code {|g| g.gen_skip one_or_more }.
          should == (<<-CODE).strip
begin
  r = false
  while @scanner.skip(/w+/)
    r = true
  end
  r
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level one-or-more skipping code' do
        top_level_code {|g| g.gen_skip one_or_more }.
          should == (<<-CODE).strip
r = false
while @scanner.skip(/w+/)
  r = true
end
r
          CODE
      end
    end
  end

  describe '#gen_intermediate' do
    it 'generates nested one-or-more matching code' do
      nested_code {|g| g.gen_intermediate one_or_more }.
        should == (<<-CODE).strip
begin
  a = []
  while r = @scanner.scan(/w+/)
    a << r
  end
  a unless a.empty?
end
        CODE
    end
  end

  describe '#gen_intermediate_assert' do
    it 'generates nested one-or-more positive lookahead code' do
      nested_code {|g| g.gen_assert one_or_more }.
      should == '(@scanner.skip(/(?=w+)/) && true)'
    end
  end

  describe '#gen_intermediate_disallow' do
    it 'generates nested one-or-more negative lookahead code' do
      nested_code {|g| g.gen_disallow one_or_more }.
      should == '(@scanner.skip(/(?!w+)/) && true)'
    end
  end

  describe '#gen_intermediate_skip' do
    it 'generates nested one-or-more skipping code' do
      nested_code {|g| g.gen_intermediate_skip one_or_more }.
        should == (<<-CODE).strip
begin
  r = false
  while @scanner.skip(/w+/)
    r = true
  end
  r
end
        CODE
    end
  end

end
