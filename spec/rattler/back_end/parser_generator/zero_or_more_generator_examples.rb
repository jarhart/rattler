require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

shared_examples_for 'a zero-or-more generator' do

  let(:bounds) { [0, nil] }
  let(:nested) { Match[/w+/] }

  describe '#gen_basic' do

    let(:nested) { Choice[Match[/[[:alpha:]]/], Match[/[[:digit:]]/]] }

    context 'given a repeat with zero-or-more bounds' do

      context 'when nested' do
        it 'generates nested zero-or-more matching code' do
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
  a
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top level zero-or-more matching code' do
          top_level_code {|g| g.gen_basic repeat }.
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
  end

  describe '#gen_assert' do

    context 'given a repeat with zero-or-more bounds' do

      context 'when nested' do
        it 'generates "true"' do
          nested_code {|g| g.gen_assert repeat }.should == 'true'
        end
      end

      context 'when top-level' do
        it 'generates "true"' do
          top_level_code {|g| g.gen_assert repeat }.should == 'true'
        end
      end
    end
  end

  describe '#gen_disallow' do

    context 'given a repeat with zero-or-more bounds' do

      context 'when nested' do
        it 'generates "false"' do
          nested_code {|g| g.gen_disallow repeat }.should == 'false'
        end
      end

      context 'when top-level' do
        it 'generates "false"' do
          top_level_code {|g| g.gen_disallow repeat }.should == 'false'
        end
      end
    end
  end

  describe '#gen_dispatch_action' do

    let(:nested) { Match[/w+/] }
    let(:code) { NodeCode.new('Word', 'parsed') }

    context 'given a repeat with zero-or-more bounds' do

      context 'when nested' do
        it 'generates nested zero-or-more matching code with a dispatch action' do
          nested_code {|g| g.gen_dispatch_action repeat, code }.
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
          top_level_code {|g| g.gen_dispatch_action repeat, code }.
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
  end

  describe '#gen_direct_action' do

    let(:nested) { Match[/w+/] }
    let(:code) { ActionCode.new('|_| _.size') }

    context 'given a repeat with zero-or-more bounds' do

      context 'when nested' do
        it 'generates nested zero-or-more matching code with a direct action' do
          nested_code {|g| g.gen_direct_action repeat, code }.
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
          top_level_code {|g| g.gen_direct_action repeat, code }.
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
  end

  describe '#gen_token' do

    let(:nested) { Match[/w+/] }

    context 'given a repeat with zero-or-more bounds' do

      context 'when nested' do
        it 'generates nested zero-or-more matching code' do
          nested_code {|g| g.gen_token repeat }.
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
          top_level_code {|g| g.gen_token repeat }.
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
  end

  describe '#gen_skip' do

    let(:nested) { Match[/w+/] }

    context 'given a repeat with zero-or-more bounds' do

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
  end

  describe '#gen_intermediate' do

    let(:nested) { Match[/w+/] }

    context 'given a repeat with zero-or-more bounds' do
      it 'generates nested zero-or-more matching code' do
        nested_code {|g| g.gen_intermediate repeat }.
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
  end

  describe '#gen_intermediate_assert' do
    context 'given a repeat with zero-or-more bounds' do
      it 'generates "true"' do
        nested_code {|g| g.gen_intermediate_assert repeat }.should == 'true'
      end
    end
  end

  describe '#gen_intermediate_disallow' do
    context 'given a repeat with zero-or-more bounds' do
      it 'generates "false"' do
        nested_code {|g| g.gen_intermediate_disallow repeat }.should == 'false'
      end
    end
  end

  describe '#gen_intermediate_skip' do

    let(:nested) { Match[/w+/] }

    context 'given a repeat with zero-or-more bounds' do
      it 'generates nested zero-or-more skipping code' do
        nested_code {|g| g.gen_intermediate_skip repeat }.
          should == (<<-CODE).strip
begin
  while @scanner.skip(/w+/); end
  true
end
          CODE
      end
    end
  end

end
