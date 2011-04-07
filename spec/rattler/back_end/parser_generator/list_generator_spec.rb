require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/list0_generator_examples')
require File.expand_path(File.dirname(__FILE__) + '/list1_generator_examples')

include Rattler::Parsers

describe Rattler::BackEnd::ParserGenerator::ListGenerator do

  include ParserGeneratorSpecHelper

  let(:list) { ListParser[term_parser, sep_parser, *bounds] }

  it_behaves_like 'a list0 generator'
  it_behaves_like 'a list1 generator'

  let(:term_parser) { Match[/w+/] }
  let(:sep_parser) { Match[/[,;]/] }

  describe '#gen_basic' do

    let(:term_parser) { Choice[Match[/[[:alpha:]]/], Match[/[[:digit:]]/]] }

    context 'given a list with no upper bound' do

      let(:bounds) { [2, nil] }

      context 'when nested' do
        it 'generates nested list matching code' do
          nested_code {|g| g.gen_basic list }.
            should == (<<-CODE).strip
begin
  a = []
  sp = @scanner.pos
  ep = nil
  while r = begin
    @scanner.scan(/[[:alpha:]]/) ||
    @scanner.scan(/[[:digit:]]/)
  end
    ep = @scanner.pos
    a << r
    break unless @scanner.skip(/[,;]/)
  end
  if a.size >= 2
    @scanner.pos = ep unless ep.nil?
    a
  else
    @scanner.pos = sp
    false
  end
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top-level list matching code' do
          top_level_code {|g| g.gen_basic list }.
            should == (<<-CODE).strip
a = []
sp = @scanner.pos
ep = nil
while r = begin
  @scanner.scan(/[[:alpha:]]/) ||
  @scanner.scan(/[[:digit:]]/)
end
  ep = @scanner.pos
  a << r
  break unless @scanner.skip(/[,;]/)
end
if a.size >= 2
  @scanner.pos = ep unless ep.nil?
  a
else
  @scanner.pos = sp
  false
end
            CODE
        end
      end
    end

    context 'given a list with an upper bound' do

      let(:bounds) { [2, 4] }

      context 'when nested' do
        it 'generates nested list matching code' do
          nested_code {|g| g.gen_basic list }.
            should == (<<-CODE).strip
begin
  a = []
  sp = @scanner.pos
  ep = nil
  while r = begin
    @scanner.scan(/[[:alpha:]]/) ||
    @scanner.scan(/[[:digit:]]/)
  end
    ep = @scanner.pos
    a << r
    break unless a.size < 4
    break unless @scanner.skip(/[,;]/)
  end
  if a.size >= 2
    @scanner.pos = ep unless ep.nil?
    a
  else
    @scanner.pos = sp
    false
  end
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top-level list matching code' do
          top_level_code {|g| g.gen_basic list }.
            should == (<<-CODE).strip
a = []
sp = @scanner.pos
ep = nil
while r = begin
  @scanner.scan(/[[:alpha:]]/) ||
  @scanner.scan(/[[:digit:]]/)
end
  ep = @scanner.pos
  a << r
  break unless a.size < 4
  break unless @scanner.skip(/[,;]/)
end
if a.size >= 2
  @scanner.pos = ep unless ep.nil?
  a
else
  @scanner.pos = sp
  false
end
            CODE
        end
      end
    end

    context 'given a non-capturing list' do

      let(:term_parser) { Skip[Match[/w+/]] }

      context 'with no upper bound' do

        let(:bounds) { [2, nil] }

        context 'when nested' do
          it 'generates nested list skipping code' do
            nested_code {|g| g.gen_basic list }.
              should == (<<-CODE).strip
begin
  c = 0
  sp = @scanner.pos
  ep = nil
  while @scanner.skip(/w+/)
    c += 1
    ep = @scanner.pos
    break unless @scanner.skip(/[,;]/)
  end
  if c >= 2
    @scanner.pos = ep unless ep.nil?
    true
  else
    @scanner.pos = sp
    false
  end
end
              CODE
          end
        end

        context 'when top-level' do
          it 'generates top-level list skipping code' do
            top_level_code {|g| g.gen_basic list }.
              should == (<<-CODE).strip
c = 0
sp = @scanner.pos
ep = nil
while @scanner.skip(/w+/)
  c += 1
  ep = @scanner.pos
  break unless @scanner.skip(/[,;]/)
end
if c >= 2
  @scanner.pos = ep unless ep.nil?
  true
else
  @scanner.pos = sp
  false
end
              CODE
          end
        end
      end

      context 'with an upper bound' do

        let(:bounds) { [2, 4] }

        context 'when nested' do
          it 'generates nested list skipping code' do
            nested_code {|g| g.gen_basic list }.
              should == (<<-CODE).strip
begin
  c = 0
  sp = @scanner.pos
  ep = nil
  while @scanner.skip(/w+/)
    c += 1
    ep = @scanner.pos
    break unless c < 4
    break unless @scanner.skip(/[,;]/)
  end
  if c >= 2
    @scanner.pos = ep unless ep.nil?
    true
  else
    @scanner.pos = sp
    false
  end
end
              CODE
          end
        end

        context 'when top-level' do
          it 'generates top-level list skipping code' do
            top_level_code {|g| g.gen_basic list }.
              should == (<<-CODE).strip
c = 0
sp = @scanner.pos
ep = nil
while @scanner.skip(/w+/)
  c += 1
  ep = @scanner.pos
  break unless c < 4
  break unless @scanner.skip(/[,;]/)
end
if c >= 2
  @scanner.pos = ep unless ep.nil?
  true
else
  @scanner.pos = sp
  false
end
              CODE
          end
        end
      end
    end
  end

  describe '#gen_assert' do

    context 'given a list with no upper bound' do

      let(:bounds) { [2, nil] }

      context 'when nested' do
        it 'generates nested positive lookahead code' do
          nested_code {|g| g.gen_assert list }.should == (<<-CODE).strip
begin
  c = 0
  sp = @scanner.pos
  while @scanner.skip(/w+/)
    c += 1
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = sp
  c >= 2
end
          CODE
        end
      end

      context 'when top-level' do
        it 'generates top-level positive lookahead code' do
          top_level_code {|g| g.gen_assert list }.should == (<<-CODE).strip
c = 0
sp = @scanner.pos
while @scanner.skip(/w+/)
  c += 1
  break unless @scanner.skip(/[,;]/)
end
@scanner.pos = sp
c >= 2
          CODE
        end
      end
    end

    context 'given a list with an upper bound' do

      let(:bounds) { [2, 4] }

      context 'when nested' do
        it 'generates nested positive lookahead code' do
          nested_code {|g| g.gen_assert list }.should == (<<-CODE).strip
begin
  c = 0
  sp = @scanner.pos
  while @scanner.skip(/w+/)
    c += 1
    break unless c < 4
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = sp
  c >= 2
end
          CODE
        end
      end

      context 'when top-level' do
        it 'generates top-level positive lookahead code' do
          top_level_code {|g| g.gen_assert list }.should == (<<-CODE).strip
c = 0
sp = @scanner.pos
while @scanner.skip(/w+/)
  c += 1
  break unless c < 4
  break unless @scanner.skip(/[,;]/)
end
@scanner.pos = sp
c >= 2
          CODE
        end
      end
    end
  end

  describe '#gen_disallow' do

    context 'given a list with no upper bound' do

      let(:bounds) { [2, nil] }

      context 'when nested' do
        it 'generates nested negative lookahead code' do
          nested_code {|g| g.gen_disallow list }.should == (<<-CODE).strip
begin
  c = 0
  sp = @scanner.pos
  while @scanner.skip(/w+/)
    c += 1
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = sp
  c < 2
end
          CODE
        end
      end

      context 'when top-level' do
        it 'generates top-level negative lookahead code' do
          top_level_code {|g| g.gen_disallow list }.should == (<<-CODE).strip
c = 0
sp = @scanner.pos
while @scanner.skip(/w+/)
  c += 1
  break unless @scanner.skip(/[,;]/)
end
@scanner.pos = sp
c < 2
          CODE
        end
      end
    end

    context 'given a list with an upper bound' do

      let(:bounds) { [2, 4] }

      context 'when nested' do
        it 'generates nested negative lookahead code' do
          nested_code {|g| g.gen_disallow list }.should == (<<-CODE).strip
begin
  c = 0
  sp = @scanner.pos
  while @scanner.skip(/w+/)
    c += 1
    break unless c < 4
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = sp
  c < 2
end
          CODE
        end
      end

      context 'when top-level' do
        it 'generates top-level negative lookahead code' do
          top_level_code {|g| g.gen_disallow list }.should == (<<-CODE).strip
c = 0
sp = @scanner.pos
while @scanner.skip(/w+/)
  c += 1
  break unless c < 4
  break unless @scanner.skip(/[,;]/)
end
@scanner.pos = sp
c < 2
          CODE
        end
      end
    end
  end

  describe '#gen_dispatch_action' do

    let(:code) { NodeCode.new('Word', 'parsed') }

    context 'given a list with an upper bound' do

      let(:bounds) { [2, 4] }

      context 'when nested' do
        it 'generates nested list matching code with a dispatch action' do
          nested_code {|g| g.gen_dispatch_action list, code }.
            should == (<<-CODE).strip
begin
  a = []
  sp = @scanner.pos
  ep = nil
  while r = @scanner.scan(/w+/)
    ep = @scanner.pos
    a << r
    break unless a.size < 4
    break unless @scanner.skip(/[,;]/)
  end
  if a.size >= 2
    @scanner.pos = ep unless ep.nil?
    Word.parsed(select_captures(a))
  else
    @scanner.pos = sp
    false
  end
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top level list matching code with a dispatch action' do
          top_level_code {|g| g.gen_dispatch_action list, code }.
            should == (<<-CODE).strip
a = []
sp = @scanner.pos
ep = nil
while r = @scanner.scan(/w+/)
  ep = @scanner.pos
  a << r
  break unless a.size < 4
  break unless @scanner.skip(/[,;]/)
end
if a.size >= 2
  @scanner.pos = ep unless ep.nil?
  Word.parsed(select_captures(a))
else
  @scanner.pos = sp
  false
end
            CODE
        end
      end
    end

    context 'given a list with no upper bound' do

      let(:bounds) { [2, nil] }

      context 'when nested' do
        it 'generates nested list matching code with a dispatch action' do
          nested_code {|g| g.gen_dispatch_action list, code }.
            should == (<<-CODE).strip
begin
  a = []
  sp = @scanner.pos
  ep = nil
  while r = @scanner.scan(/w+/)
    ep = @scanner.pos
    a << r
    break unless @scanner.skip(/[,;]/)
  end
  if a.size >= 2
    @scanner.pos = ep unless ep.nil?
    Word.parsed(select_captures(a))
  else
    @scanner.pos = sp
    false
  end
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top level list matching code with a dispatch action' do
          top_level_code {|g| g.gen_dispatch_action list, code }.
            should == (<<-CODE).strip
a = []
sp = @scanner.pos
ep = nil
while r = @scanner.scan(/w+/)
  ep = @scanner.pos
  a << r
  break unless @scanner.skip(/[,;]/)
end
if a.size >= 2
  @scanner.pos = ep unless ep.nil?
  Word.parsed(select_captures(a))
else
  @scanner.pos = sp
  false
end
            CODE
        end
      end
    end
  end

  describe '#gen_direct_action' do

    let(:code) { ActionCode.new('|_| _.size') }

    context 'given a list with an upper bound' do

      let(:bounds) { [2, 4] }

      context 'when nested' do
        it 'generates nested list matching code with a dispatch action' do
          nested_code {|g| g.gen_direct_action list, code }.
            should == (<<-CODE).strip
begin
  a = []
  sp = @scanner.pos
  ep = nil
  while r = @scanner.scan(/w+/)
    ep = @scanner.pos
    a << r
    break unless a.size < 4
    break unless @scanner.skip(/[,;]/)
  end
  if a.size >= 2
    @scanner.pos = ep unless ep.nil?
    (select_captures(a).size)
  else
    @scanner.pos = sp
    false
  end
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top level list matching code with a dispatch action' do
          top_level_code {|g| g.gen_direct_action list, code }.
            should == (<<-CODE).strip
a = []
sp = @scanner.pos
ep = nil
while r = @scanner.scan(/w+/)
  ep = @scanner.pos
  a << r
  break unless a.size < 4
  break unless @scanner.skip(/[,;]/)
end
if a.size >= 2
  @scanner.pos = ep unless ep.nil?
  (select_captures(a).size)
else
  @scanner.pos = sp
  false
end
            CODE
        end
      end
    end

    context 'given a list with no upper bound' do

      let(:bounds) { [2, nil] }

      context 'when nested' do
        it 'generates nested list matching code with a dispatch action' do
          nested_code {|g| g.gen_direct_action list, code }.
            should == (<<-CODE).strip
begin
  a = []
  sp = @scanner.pos
  ep = nil
  while r = @scanner.scan(/w+/)
    ep = @scanner.pos
    a << r
    break unless @scanner.skip(/[,;]/)
  end
  if a.size >= 2
    @scanner.pos = ep unless ep.nil?
    (select_captures(a).size)
  else
    @scanner.pos = sp
    false
  end
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top level list matching code with a dispatch action' do
          top_level_code {|g| g.gen_direct_action list, code }.
            should == (<<-CODE).strip
a = []
sp = @scanner.pos
ep = nil
while r = @scanner.scan(/w+/)
  ep = @scanner.pos
  a << r
  break unless @scanner.skip(/[,;]/)
end
if a.size >= 2
  @scanner.pos = ep unless ep.nil?
  (select_captures(a).size)
else
  @scanner.pos = sp
  false
end
            CODE
        end
      end
    end
  end

  describe '#gen_skip' do

    context 'given a list with no upper bound' do

      let(:bounds) { [2, nil] }

      context 'when nested' do
        it 'generates nested list skipping code' do
          nested_code {|g| g.gen_skip list }.should == (<<-CODE).strip
begin
  c = 0
  sp = @scanner.pos
  ep = nil
  while @scanner.skip(/w+/)
    c += 1
    ep = @scanner.pos
    break unless @scanner.skip(/[,;]/)
  end
  if c >= 2
    @scanner.pos = ep unless ep.nil?
    true
  else
    @scanner.pos = sp
    false
  end
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top-level list skipping code' do
          top_level_code {|g| g.gen_skip list }.should == (<<-CODE).strip
c = 0
sp = @scanner.pos
ep = nil
while @scanner.skip(/w+/)
  c += 1
  ep = @scanner.pos
  break unless @scanner.skip(/[,;]/)
end
if c >= 2
  @scanner.pos = ep unless ep.nil?
  true
else
  @scanner.pos = sp
  false
end
            CODE
        end
      end
    end

    context 'given a list with an upper bound' do

      let(:bounds) { [2, 4] }

      context 'when nested' do
        it 'generates nested list skipping code' do
          nested_code {|g| g.gen_skip list }.
            should == (<<-CODE).strip
begin
  c = 0
  sp = @scanner.pos
  ep = nil
  while @scanner.skip(/w+/)
    c += 1
    ep = @scanner.pos
    break unless c < 4
    break unless @scanner.skip(/[,;]/)
  end
  if c >= 2
    @scanner.pos = ep unless ep.nil?
    true
  else
    @scanner.pos = sp
    false
  end
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top-level list skipping code' do
          top_level_code {|g| g.gen_skip list }.
            should == (<<-CODE).strip
c = 0
sp = @scanner.pos
ep = nil
while @scanner.skip(/w+/)
  c += 1
  ep = @scanner.pos
  break unless c < 4
  break unless @scanner.skip(/[,;]/)
end
if c >= 2
  @scanner.pos = ep unless ep.nil?
  true
else
  @scanner.pos = sp
  false
end
            CODE
        end
      end
    end
  end

end
