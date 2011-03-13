require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::ParserGenerator
include Rattler::Parsers

describe ListGenerator do

  include ParserGeneratorSpecHelper

  let(:list) { List[Match[/w+/], Match[/[,;]/]] }

  describe '#gen_basic' do

    let :list do
      List[Choice[Match[/[[:alpha:]]/], Match[/[[:digit:]]/]], Match[/[,;]/]]
    end

    context 'when nested' do
      it 'generates nested list matching code' do
        nested_code {|g| g.gen_basic list }.
          should == (<<-CODE).strip
begin
  a = []
  lp = nil
  while r = begin
    @scanner.scan(/[[:alpha:]]/) ||
    @scanner.scan(/[[:digit:]]/)
  end
    lp = @scanner.pos
    a << r
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = lp unless lp.nil?
  a
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top-level list matching code' do
        top_level_code {|g| g.gen_basic list }.
          should == (<<-CODE).strip
a = []
lp = nil
while r = begin
  @scanner.scan(/[[:alpha:]]/) ||
  @scanner.scan(/[[:digit:]]/)
end
  lp = @scanner.pos
  a << r
  break unless @scanner.skip(/[,;]/)
end
@scanner.pos = lp unless lp.nil?
a
          CODE
      end
    end

    context 'with a non-capturing parser' do

      let(:list) { List[Skip[Match[/w+/]], Match[/[,;]/]] }

      context 'when nested' do
        it 'generates nested list skipping code' do
          nested_code {|g| g.gen_basic list }.
            should == (<<-CODE).strip
begin
  lp = nil
  while @scanner.skip(/w+/)
    lp = @scanner.pos
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = lp unless lp.nil?
  true
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates nested list skipping code' do
          top_level_code {|g| g.gen_basic list }.
            should == (<<-CODE).strip
lp = nil
while @scanner.skip(/w+/)
  lp = @scanner.pos
  break unless @scanner.skip(/[,;]/)
end
@scanner.pos = lp unless lp.nil?
true
            CODE
        end
      end
    end
  end

  describe '#gen_assert' do

    context 'when nested' do
      it 'generates "true"' do
        nested_code {|g| g.gen_assert list }.should == 'true'
      end
    end

    context 'when top-level' do
      it 'generates "true"' do
        top_level_code {|g| g.gen_assert list }.should == 'true'
      end
    end
  end

  describe '#gen_disallow' do

    context 'when nested' do
      it 'generates "false"' do
        nested_code {|g| g.gen_disallow list }.should == 'false'
      end
    end

    context 'when top-level' do
      it 'generates "false"' do
        top_level_code {|g| g.gen_disallow list }.should == 'false'
      end
    end
  end

  describe '#gen_dispatch_action' do

    let(:code) { NodeCode.new('Word', 'parsed') }

    context 'when nested' do
      it 'generates nested list matching code with a dispatch action' do
        nested_code {|g| g.gen_dispatch_action list, code }.
          should == (<<-CODE).strip
begin
  a = []
  lp = nil
  while r = @scanner.scan(/w+/)
    lp = @scanner.pos
    a << r
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = lp unless lp.nil?
  Word.parsed(select_captures(a))
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level list matching code with a dispatch action' do
        top_level_code {|g| g.gen_dispatch_action list, code }.
          should == (<<-CODE).strip
a = []
lp = nil
while r = @scanner.scan(/w+/)
  lp = @scanner.pos
  a << r
  break unless @scanner.skip(/[,;]/)
end
@scanner.pos = lp unless lp.nil?
Word.parsed(select_captures(a))
          CODE
      end
    end
  end

  describe '#gen_direct_action' do

    let(:code) { ActionCode.new('|_| _.size') }

    context 'when nested' do
      it 'generates nested list matching code with a dispatch action' do
        nested_code {|g| g.gen_direct_action list, code }.
          should == (<<-CODE).strip
begin
  a = []
  lp = nil
  while r = @scanner.scan(/w+/)
    lp = @scanner.pos
    a << r
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = lp unless lp.nil?
  (select_captures(a).size)
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level list matching code with a dispatch action' do
        top_level_code {|g| g.gen_direct_action list, code }.
          should == (<<-CODE).strip
a = []
lp = nil
while r = @scanner.scan(/w+/)
  lp = @scanner.pos
  a << r
  break unless @scanner.skip(/[,;]/)
end
@scanner.pos = lp unless lp.nil?
(select_captures(a).size)
          CODE
      end
    end
  end

  describe '#gen_skip' do

    context 'when nested' do
      it 'generates nested list skipping code' do
        nested_code {|g| g.gen_skip list }.
          should == (<<-CODE).strip
begin
  lp = nil
  while @scanner.skip(/w+/)
    lp = @scanner.pos
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = lp unless lp.nil?
  true
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top-level list skipping code' do
        top_level_code {|g| g.gen_skip list }.
          should == (<<-CODE).strip
lp = nil
while @scanner.skip(/w+/)
  lp = @scanner.pos
  break unless @scanner.skip(/[,;]/)
end
@scanner.pos = lp unless lp.nil?
true
          CODE
      end
    end
  end

  describe '#gen_intermediate' do
    it 'generates nested list matching code' do
      nested_code {|g| g.gen_intermediate list }.
        should == (<<-CODE).strip
begin
  a = []
  lp = nil
  while r = @scanner.scan(/w+/)
    lp = @scanner.pos
    a << r
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = lp unless lp.nil?
  a
end
        CODE
    end
  end

  describe '#gen_intermediate_assert' do
    it 'generates "true"' do
      nested_code {|g| g.gen_intermediate_assert list }.should == 'true'
    end
  end

  describe '#gen_intermediate_disallow' do
    it 'generates "false"' do
      nested_code {|g| g.gen_intermediate_disallow list }.should == 'false'
    end
  end

  describe '#gen_intermediate_skip' do
    it 'generates nested list skipping code' do
      nested_code {|g| g.gen_intermediate_skip list }.
        should == (<<-CODE).strip
begin
  lp = nil
  while @scanner.skip(/w+/)
    lp = @scanner.pos
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = lp unless lp.nil?
  true
end
        CODE
    end
  end

end
