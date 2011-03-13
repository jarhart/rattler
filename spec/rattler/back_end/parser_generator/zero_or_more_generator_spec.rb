require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::ParserGenerator
include Rattler::Parsers

describe ZeroOrMoreGenerator do

  include ParserGeneratorSpecHelper

  let(:zero_or_more) { ZeroOrMore[Match[/w+/]] }

  describe '#gen_basic' do

    let :zero_or_more do
      ZeroOrMore[Choice[Match[/[[:alpha:]]/], Match[/[[:digit:]]/]]]
    end

    context 'when nested' do
      it 'generates nested zero-or-more matching code' do
        nested_code {|g| g.gen_basic zero_or_more }.
          should == (<<-CODE).strip
begin
  a = []
  while r = begin
    @scanner.scan(/[[:alpha:]]/) ||
    @scanner.scan(/[[:digit:]]/)
  end
    a << r
  end
  a
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level zero-or-more matching code' do
        top_level_code {|g| g.gen_basic zero_or_more }.
          should == (<<-CODE).strip
a = []
while r = begin
  @scanner.scan(/[[:alpha:]]/) ||
  @scanner.scan(/[[:digit:]]/)
end
  a << r
end
a
          CODE
      end
    end
  end

  describe '#gen_assert' do

    context 'when nested' do
      it 'generates "true"' do
        nested_code {|g| g.gen_assert zero_or_more }.should == 'true'
      end
    end

    context 'when top-level' do
      it 'generates "true"' do
        top_level_code {|g| g.gen_assert zero_or_more }.should == 'true'
      end
    end
  end

  describe '#gen_disallow' do

    context 'when nested' do
      it 'generates "false"' do
        nested_code {|g| g.gen_disallow zero_or_more }.should == 'false'
      end
    end

    context 'when top-level' do
      it 'generates "false"' do
        top_level_code {|g| g.gen_disallow zero_or_more }.should == 'false'
      end
    end
  end

  describe '#gen_dispatch_action' do

    let(:code) { NodeCode.new('Word', 'parsed') }

    context 'when nested' do
      it 'generates nested zero-or-more matching code with a dispatch action' do
        nested_code {|g| g.gen_dispatch_action zero_or_more, code }.
          should == (<<-CODE).strip
begin
  a = []
  while r = @scanner.scan(/w+/)
    a << r
  end
  Word.parsed(select_captures(a))
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level zero-or-more matching code with a dispatch action' do
        top_level_code {|g| g.gen_dispatch_action zero_or_more, code }.
          should == (<<-CODE).strip
a = []
while r = @scanner.scan(/w+/)
  a << r
end
Word.parsed(select_captures(a))
          CODE
      end
    end
  end

  describe '#gen_direct_action' do

    let(:code) { ActionCode.new('|_| _.size') }

    context 'when nested' do
      it 'generates nested zero-or-more matching code with a direct action' do
        nested_code {|g| g.gen_direct_action zero_or_more, code }.
          should == (<<-CODE).strip
begin
  a = []
  while r = @scanner.scan(/w+/)
    a << r
  end
  (select_captures(a).size)
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level zero-or-more matching code with a direct action' do
        top_level_code {|g| g.gen_direct_action zero_or_more, code }.
          should == (<<-CODE).strip
a = []
while r = @scanner.scan(/w+/)
  a << r
end
(select_captures(a).size)
          CODE
      end
    end
  end

  describe '#gen_token' do

    context 'when nested' do
      it 'generates nested zero-or-more matching code' do
        nested_code {|g| g.gen_token zero_or_more }.
          should == (<<-CODE).strip
begin
  a = []
  while r = @scanner.scan(/w+/)
    a << r
  end
  a.join
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level zero-or-more matching code' do
        top_level_code {|g| g.gen_token zero_or_more }.
          should == (<<-CODE).strip
a = []
while r = @scanner.scan(/w+/)
  a << r
end
a.join
          CODE
      end
    end
  end

  describe '#gen_skip' do

    context 'when nested' do
      it 'generates nested zero-or-more skipping code' do
        nested_code {|g| g.gen_skip zero_or_more }.
          should == (<<-CODE).strip
begin
  while @scanner.skip(/w+/); end
  true
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level zero-or-more skipping code' do
        top_level_code {|g| g.gen_skip zero_or_more }.
          should == (<<-CODE).strip
while @scanner.skip(/w+/); end
true
          CODE
      end
    end
  end

  describe '#gen_intermediate' do
    it 'generates nested zero-or-more matching code' do
      nested_code {|g| g.gen_intermediate zero_or_more }.
        should == (<<-CODE).strip
begin
  a = []
  while r = @scanner.scan(/w+/)
    a << r
  end
  a
end
        CODE
    end
  end

  describe '#gen_intermediate_assert' do
    it 'generates "true"' do
      nested_code {|g| g.gen_intermediate_assert zero_or_more }.should == 'true'
    end
  end

  describe '#gen_intermediate_disallow' do
    it 'generates "false"' do
      nested_code {|g| g.gen_intermediate_disallow zero_or_more }.should == 'false'
    end
  end

  describe '#gen_intermediate_skip' do
    it 'generates nested zero-or-more skipping code' do
      nested_code {|g| g.gen_intermediate_skip zero_or_more }.
        should == (<<-CODE).strip
begin
  while @scanner.skip(/w+/); end
  true
end
        CODE
    end
  end

end
