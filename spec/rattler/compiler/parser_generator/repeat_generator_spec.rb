require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/zero_or_more_generator_examples')
require File.expand_path(File.dirname(__FILE__) + '/one_or_more_generator_examples')
require File.expand_path(File.dirname(__FILE__) + '/optional_generator_examples')

include Rattler::Compiler::ParserGenerator
include Rattler::Parsers

describe RepeatGenerator do

  include ParserGeneratorSpecHelper

  let(:repeat) { Repeat[nested, *bounds] }

  it_behaves_like 'a zero-or-more generator'
  it_behaves_like 'a one-or-more generator'
  it_behaves_like 'an optional generator'

  describe '#gen_basic' do

    context 'with an upper bound' do

      let(:bounds) { [2, 4] }
      let(:nested) { Match[/w+/] }

      context 'when nested' do
        it 'generates nested repeat matching code' do
          nested_code {|g| g.gen_basic repeat }.should == (<<-CODE).strip
begin
  a = []
  rp = @scanner.pos
  while r = @scanner.scan(/\w+/)
    a << r
    break if a.size >= 4
  end
  if a.size >= 2
    a
  else
    @scanner.pos = rp
    false
  end
end
          CODE
        end
      end

      context 'when top-level' do
        it 'generates nested repeat matching code' do
          top_level_code {|g| g.gen_basic repeat }.should == (<<-CODE).strip
a = []
rp = @scanner.pos
while r = @scanner.scan(/\w+/)
  a << r
  break if a.size >= 4
end
if a.size >= 2
  a
else
  @scanner.pos = rp
  false
end
          CODE
        end
      end
    end

    context 'with no upper bound' do

      let(:bounds) { [2, nil] }
      let(:nested) { Match[/w+/] }

      context 'when nested' do
        it 'generates nested repeat matching code' do
          nested_code {|g| g.gen_basic repeat }.should == (<<-CODE).strip
begin
  a = []
  rp = @scanner.pos
  while r = @scanner.scan(/\w+/)
    a << r
  end
  if a.size >= 2
    a
  else
    @scanner.pos = rp
    false
  end
end
          CODE
        end
      end

      context 'when top-level' do
        it 'generates nested repeat matching code' do
          top_level_code {|g| g.gen_basic repeat }.should == (<<-CODE).strip
a = []
rp = @scanner.pos
while r = @scanner.scan(/\w+/)
  a << r
end
if a.size >= 2
  a
else
  @scanner.pos = rp
  false
end
          CODE
        end
      end
    end

    context 'with an Apply parser' do

      let(:bounds) { [0, nil] }
      let(:nested) { Apply[:a] }

      it 'generates repeat code that selects only the captures for the result' do
        top_level_code {|g| g.gen_basic repeat }.should == <<-CODE.strip
a = []
while r = match(:a)
  a << r
end
select_captures(a)
        CODE
      end
    end

    context 'with a choice of capturing or non-capturing parsers' do

      let(:bounds) { [0, nil] }
      let(:nested) { Choice[
        Match[/a/],
        Skip[Match[/b/]]
      ] }

      it 'generates repeat code that selects only the captures for the result' do
        top_level_code {|g| g.gen_basic repeat }.should == <<-CODE.strip
a = []
while r = begin
  @scanner.scan(/a/) ||
  (@scanner.skip(/b/) && true)
end
  a << r
end
select_captures(a)
        CODE
      end
    end

    context 'with an attributed sequence with a semantic action' do

      let(:bounds) { [0, nil] }
      let(:nested) do
        AttributedSequence[Match[/\w/], SemanticAction['_']]
      end

      it 'generates repeat code that selects only the captures for the result' do
        top_level_code {|g| g.gen_basic repeat }.should == <<-'CODE'.strip
a = []
while r = begin
  p0 = @scanner.pos
  begin
    (r0_0 = @scanner.scan(/\w/)) &&
    (r0_0)
  end || begin
    @scanner.pos = p0
    false
  end
end
  a << r
end
select_captures(a)
        CODE
      end
    end
  end

  describe '#gen_assert' do

    let(:bounds) { [2, 4] }
    let(:nested) { Match[/w+/] }

    context 'when nested' do
      it 'generates nested repeat positive lookahead code' do
        nested_code {|g| g.gen_assert repeat }.should == (<<-CODE).strip
begin
  c = 0
  rp = @scanner.pos
  while @scanner.skip(/\w+/)
    c += 1
    break if c >= 2
  end
  @scanner.pos = rp
  (c >= 2)
end
        CODE
      end
    end

    context 'when top-level' do
      it 'generates top level repeat positive lookahead code' do
        top_level_code {|g| g.gen_assert repeat }.should == (<<-CODE).strip
c = 0
rp = @scanner.pos
while @scanner.skip(/\w+/)
  c += 1
  break if c >= 2
end
@scanner.pos = rp
(c >= 2)
        CODE
      end
    end
  end

  describe '#gen_disallow' do

    let(:bounds) { [2, 4] }
    let(:nested) { Match[/w+/] }

    context 'when nested' do
      it 'generates nested repeat negative lookahead code' do
        nested_code {|g| g.gen_disallow repeat }.should == (<<-CODE).strip
begin
  c = 0
  rp = @scanner.pos
  while @scanner.skip(/\w+/)
    c += 1
    break if c >= 2
  end
  @scanner.pos = rp
  (c < 2)
end
        CODE
      end
    end

    context 'when top-level' do
      it 'generates top level repeat negative lookahead code' do
        top_level_code {|g| g.gen_disallow repeat }.should == (<<-CODE).strip
c = 0
rp = @scanner.pos
while @scanner.skip(/\w+/)
  c += 1
  break if c >= 2
end
@scanner.pos = rp
(c < 2)
        CODE
      end
    end
  end

  describe '#gen_skip' do

    context 'with an upper bound' do

      let(:bounds) { [2, 4] }
      let(:nested) { Match[/w+/] }

      context 'when nested' do
        it 'generates nested repeat skipping code' do
          nested_code {|g| g.gen_skip repeat }.should == (<<-CODE).strip
begin
  c = 0
  rp = @scanner.pos
  while @scanner.skip(/w+/)
    c += 1
    break if c >= 4
  end
  if c >= 2
    true
  else
    @scanner.pos = rp
    false
  end
end
          CODE
        end
      end

      context 'when top-level' do
        it 'generates top level repeat skipping code' do
          top_level_code {|g| g.gen_skip repeat }.should == (<<-CODE).strip
c = 0
rp = @scanner.pos
while @scanner.skip(/w+/)
  c += 1
  break if c >= 4
end
if c >= 2
  true
else
  @scanner.pos = rp
  false
end
          CODE
        end
      end
    end

    context 'with no upper bound' do

      let(:bounds) { [2, nil] }
      let(:nested) { Match[/w+/] }

      context 'when nested' do
        it 'generates nested repeat skipping code' do
          nested_code {|g| g.gen_skip repeat }.should == (<<-CODE).strip
begin
  c = 0
  rp = @scanner.pos
  while @scanner.skip(/w+/)
    c += 1
  end
  if c >= 2
    true
  else
    @scanner.pos = rp
    false
  end
end
          CODE
        end
      end

      context 'when top-level' do
        it 'generates top level repeat skipping code' do
          top_level_code {|g| g.gen_skip repeat }.should == (<<-CODE).strip
c = 0
rp = @scanner.pos
while @scanner.skip(/w+/)
  c += 1
end
if c >= 2
  true
else
  @scanner.pos = rp
  false
end
          CODE
        end
      end
    end
  end

end
