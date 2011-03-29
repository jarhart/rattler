require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::ParserGenerator
include Rattler::Parsers

describe RepeatGenerator do

  include ParserGeneratorSpecHelper

  let(:child) { Match[/w+/] }

  describe '#gen_basic' do

    context 'with an upper bound' do

      let(:repeat) { Repeat[child, 2, 4] }

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

      let(:repeat) { Repeat[child, 2, nil] }

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
  end

  describe '#gen_assert' do

    let(:repeat) { Repeat[child, 2, 4] }

    context 'when nested' do
      it 'generates nested one-or-more positive lookahead code' do
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
      it 'generates top level one-or-more positive lookahead code' do
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

    let(:repeat) { Repeat[child, 2, 4] }

    context 'when nested' do
      it 'generates nested one-or-more negative lookahead code' do
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
      it 'generates top level one-or-more negative lookahead code' do
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

      let(:repeat) { Repeat[child, 2, 4] }

      context 'when nested' do
        it 'generates nested zero-or-more skipping code' do
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
        it 'generates top level zero-or-more skipping code' do
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

      let(:repeat) { Repeat[child, 2, nil] }

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

    context 'with zero-or-more bounds' do

      let(:repeat) { Repeat[child, 0, nil] }

      context 'when nested' do
        it 'generates nested zero-or-more skipping code' do
          nested_code {|g| g.gen_skip repeat }.should == (<<-CODE).strip
begin
  while @scanner.skip(/w+/); end
  true
end
          CODE
        end
      end

      context 'when top-level' do
        it 'generates top level zero-or-more skipping code' do
          top_level_code {|g| g.gen_skip repeat }.should == (<<-CODE).strip
while @scanner.skip(/w+/); end
true
          CODE
        end
      end
    end

    context 'with one-or-more bounds' do

      let(:repeat) { Repeat[child, 1, nil] }

      context 'when nested' do
        it 'generates nested one-or-more skipping code' do
          nested_code {|g| g.gen_skip repeat }.should == (<<-CODE).strip
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
          top_level_code {|g| g.gen_skip repeat }.should == (<<-CODE).strip
r = false
while @scanner.skip(/w+/)
  r = true
end
r
          CODE
        end
      end
    end
  end

end
