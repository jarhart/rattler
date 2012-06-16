require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

shared_examples_for 'a one-or-more generator' do

  let(:bounds) { [1, nil] }
  let(:nested) { Match[/w+/] }

  describe '#gen_basic' do

    let(:nested) { Choice[Match[/[[:alpha:]]/], Match[/[[:digit:]]/]] }

    context 'given a repeat with one-or-more bounds' do

      context 'when nested' do
        it 'generates nested one-or-more matching code' do
          nested_code {|g| g.gen_basic repeat }.
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
          top_level_code {|g| g.gen_basic repeat }.
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
  end

  describe '#gen_assert' do

    context 'given a repeat with one-or-more bounds' do

      context 'when nested' do
        it 'generates nested one-or-more positive lookahead code' do
          nested_code {|g| g.gen_assert repeat }.
            should == '(@scanner.skip(/(?=w+)/) && true)'
        end
      end

      context 'when top-level' do
        it 'generates top level one-or-more positive lookahead code' do
          top_level_code {|g| g.gen_assert repeat }.
            should == '@scanner.skip(/(?=w+)/) && true'
        end
      end
    end
  end

  describe '#gen_disallow' do

    context 'given a repeat with one-or-more bounds' do

      context 'when nested' do
        it 'generates nested one-or-more negative lookahead code' do
          nested_code {|g| g.gen_disallow repeat }.
            should == '(@scanner.skip(/(?!w+)/) && true)'
        end
      end

      context 'when top-level' do
        it 'generates nested one-or-more negative lookahead code' do
          top_level_code {|g| g.gen_disallow repeat }.
            should == '@scanner.skip(/(?!w+)/) && true'
        end
      end
    end
  end

  describe '#gen_token' do

    let(:nested) { Match[/w+/] }

    context 'given a repeat with one-or-more bounds' do

      context 'when nested' do
        it 'generates nested one-or-more matching code' do
          nested_code {|g| g.gen_token repeat }.
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
          top_level_code {|g| g.gen_token repeat }.
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
  end

  describe '#gen_skip' do

    let(:nested) { Match[/w+/] }

    context 'given a repeat with one-or-more bounds' do

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

  describe '#gen_intermediate' do

    let(:nested) { Match[/w+/] }

    context 'given a repeat with one-or-more bounds' do
      it 'generates nested one-or-more matching code' do
        nested_code {|g| g.gen_intermediate repeat }.
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
  end

  describe '#gen_intermediate_assert' do
    context 'given a repeat with one-or-more bounds' do
      it 'generates nested one-or-more positive lookahead code' do
        nested_code {|g| g.gen_assert repeat }.
        should == '(@scanner.skip(/(?=w+)/) && true)'
      end
    end
  end

  describe '#gen_intermediate_disallow' do
    context 'given a repeat with one-or-more bounds' do
      it 'generates nested one-or-more negative lookahead code' do
        nested_code {|g| g.gen_disallow repeat }.
        should == '(@scanner.skip(/(?!w+)/) && true)'
      end
    end
  end

  describe '#gen_intermediate_skip' do

    let(:nested) { Match[/w+/] }

    context 'given a repeat with one-or-more bounds' do
      it 'generates nested one-or-more skipping code' do
        nested_code {|g| g.gen_intermediate_skip repeat }.
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

end
