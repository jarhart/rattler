require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Parsers

describe Rattler::BackEnd::ParserGenerator::List1Generator do

  include ParserGeneratorSpecHelper

  let(:list) { List1[Match[/w+/], Match[/[,;]/]] }

  describe '#gen_basic' do

    let :list do
      List1[Choice[Match[/[[:alpha:]]/], Match[/[[:digit:]]/]], Match[/[,;]/]]
    end

    context 'when nested' do
      it 'generates nested list1 matching code' do
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
  a unless a.empty?
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top-level list1 matching code' do
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
a unless a.empty?
          CODE
      end
    end

    context 'with a non-capturing parser' do

      let(:list) { List1[Skip[Match[/w+/]], Match[/[,;]/]] }

      context 'when nested' do
        it 'generates nested list skipping code' do
          nested_code {|g| g.gen_basic list }.
            should == (<<-CODE).strip
begin
  r = false
  lp = nil
  while @scanner.skip(/w+/)
    r = true
    lp = @scanner.pos
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = lp unless lp.nil?
  r
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates nested list skipping code' do
          top_level_code {|g| g.gen_basic list }.
            should == (<<-CODE).strip
r = false
lp = nil
while @scanner.skip(/w+/)
  r = true
  lp = @scanner.pos
  break unless @scanner.skip(/[,;]/)
end
@scanner.pos = lp unless lp.nil?
r
            CODE
        end
      end
    end
  end

  describe '#gen_assert' do

    context 'when nested' do
      it 'generates nested positive lookahead code' do
        nested_code {|g| g.gen_assert list }.
          should == '(@scanner.skip(/(?=w+)/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top-level positive lookahead code' do
        top_level_code {|g| g.gen_assert list }.
          should == '@scanner.skip(/(?=w+)/) && true'
      end
    end
  end

  describe '#gen_disallow' do

    context 'when nested' do
      it 'generates nested one-or-more negative lookahead code' do
        nested_code {|g| g.gen_disallow list }.
          should == '(@scanner.skip(/(?!w+)/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top-level one-or-more negative lookahead code' do
        top_level_code {|g| g.gen_disallow list }.
          should == '@scanner.skip(/(?!w+)/) && true'
      end
    end
  end

  describe '#gen_dispatch_action' do

    context 'when nested' do
      it 'generates nested list matching code with a dispatch action' do
        nested_code {|g| g.gen_dispatch_action list, 'Word', 'parsed' }.
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
  Word.parsed(select_captures(a)) unless a.empty?
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level list matching code with a dispatch action' do
        top_level_code {|g| g.gen_dispatch_action list, 'Word', 'parsed' }.
          should == (<<-CODE).strip
a = []
lp = nil
while r = @scanner.scan(/w+/)
  lp = @scanner.pos
  a << r
  break unless @scanner.skip(/[,;]/)
end
@scanner.pos = lp unless lp.nil?
Word.parsed(select_captures(a)) unless a.empty?
          CODE
      end
    end
  end

  describe '#gen_direct_action' do

    context 'when nested' do
      it 'generates nested list matching code with a dispatch action' do
        nested_code {|g| g.gen_direct_action list, ActionCode.new('|_| _.size') }.
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
  (select_captures(a).size) unless a.empty?
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level list matching code with a dispatch action' do
        top_level_code {|g| g.gen_direct_action list, ActionCode.new('|_| _.size') }.
          should == (<<-CODE).strip
a = []
lp = nil
while r = @scanner.scan(/w+/)
  lp = @scanner.pos
  a << r
  break unless @scanner.skip(/[,;]/)
end
@scanner.pos = lp unless lp.nil?
(select_captures(a).size) unless a.empty?
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
  r = false
  lp = nil
  while @scanner.skip(/w+/)
    r = true
    lp = @scanner.pos
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = lp unless lp.nil?
  r
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates nested list skipping code' do
        top_level_code {|g| g.gen_skip list }.
          should == (<<-CODE).strip
r = false
lp = nil
while @scanner.skip(/w+/)
  r = true
  lp = @scanner.pos
  break unless @scanner.skip(/[,;]/)
end
@scanner.pos = lp unless lp.nil?
r
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
  a unless a.empty?
end
        CODE
    end
  end

  describe '#gen_intermediate_assert' do
    it 'generates nested positive lookahead code' do
      nested_code {|g| g.gen_assert list }.
        should == '(@scanner.skip(/(?=w+)/) && true)'
    end
  end

  describe '#gen_intermediate_disallow' do
    it 'generates nested one-or-more negative lookahead code' do
      nested_code {|g| g.gen_disallow list }.
        should == '(@scanner.skip(/(?!w+)/) && true)'
    end
  end

  describe '#gen_intermediate_skip' do
    it 'generates nested list skipping code' do
      nested_code {|g| g.gen_intermediate_skip list }.
        should == (<<-CODE).strip
begin
  r = false
  lp = nil
  while @scanner.skip(/w+/)
    r = true
    lp = @scanner.pos
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = lp unless lp.nil?
  r
end
        CODE
    end
  end

end
