require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

shared_examples_for 'a list0 generator' do

  let(:term_parser) { Match[/w+/] }
  let(:sep_parser) { Match[/[,;]/] }
  let(:bounds) { [0, nil] }

  describe '#gen_basic' do

    let(:term_parser) { Choice[Match[/[[:alpha:]]/], Match[/[[:digit:]]/]] }

    context 'given a list with zero-or-more bounds' do

      context 'when nested' do
        it 'generates nested list matching code' do
          nested_code {|g| g.gen_basic list }.
            should == (<<-CODE).strip
begin
  a = []
  ep = nil
  while r = begin
    @scanner.scan(/[[:alpha:]]/) ||
    @scanner.scan(/[[:digit:]]/)
  end
    ep = @scanner.pos
    a << r
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = ep unless ep.nil?
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
ep = nil
while r = begin
  @scanner.scan(/[[:alpha:]]/) ||
  @scanner.scan(/[[:digit:]]/)
end
  ep = @scanner.pos
  a << r
  break unless @scanner.skip(/[,;]/)
end
@scanner.pos = ep unless ep.nil?
a
            CODE
        end
      end
    end

    context 'given a non-capturing list' do

      let(:term_parser) { Skip[Match[/w+/]] }

      context 'with zero-or-more bounds' do

        context 'when nested' do
          it 'generates nested list skipping code' do
            nested_code {|g| g.gen_basic list }.
              should == (<<-CODE).strip
begin
  ep = nil
  while @scanner.skip(/w+/)
    ep = @scanner.pos
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = ep unless ep.nil?
  true
end
              CODE
          end
        end

        context 'when top-level' do
          it 'generates nested list skipping code' do
            top_level_code {|g| g.gen_basic list }.
              should == (<<-CODE).strip
ep = nil
while @scanner.skip(/w+/)
  ep = @scanner.pos
  break unless @scanner.skip(/[,;]/)
end
@scanner.pos = ep unless ep.nil?
true
              CODE
          end
        end
      end
    end

  end

  describe '#gen_assert' do

    context 'given a list with zero-or-more bounds' do

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
  end

  describe '#gen_disallow' do

    context 'given a list with zero-or-more bounds' do

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
  end

  describe '#gen_skip' do

    context 'given a list with zero-or-more bounds' do

      context 'when nested' do
        it 'generates nested list skipping code' do
          nested_code {|g| g.gen_skip list }.
            should == (<<-CODE).strip
begin
  ep = nil
  while @scanner.skip(/w+/)
    ep = @scanner.pos
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = ep unless ep.nil?
  true
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top-level list skipping code' do
          top_level_code {|g| g.gen_skip list }.
            should == (<<-CODE).strip
ep = nil
while @scanner.skip(/w+/)
  ep = @scanner.pos
  break unless @scanner.skip(/[,;]/)
end
@scanner.pos = ep unless ep.nil?
true
            CODE
        end
      end
    end
  end

  describe '#gen_intermediate' do

    context 'given a list with zero-or-more bounds' do
      it 'generates nested list matching code' do
        nested_code {|g| g.gen_intermediate list }.
          should == (<<-CODE).strip
begin
  a = []
  ep = nil
  while r = @scanner.scan(/w+/)
    ep = @scanner.pos
    a << r
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = ep unless ep.nil?
  a
end
        CODE
      end
    end
  end

  describe '#gen_intermediate_assert' do

    context 'given a list with zero-or-more bounds' do
      it 'generates "true"' do
        nested_code {|g| g.gen_intermediate_assert list }.should == 'true'
      end
    end
  end

  describe '#gen_intermediate_disallow' do

    context 'given a list with zero-or-more bounds' do
      it 'generates "false"' do
        nested_code {|g| g.gen_intermediate_disallow list }.should == 'false'
      end
    end
  end

  describe '#gen_intermediate_skip' do

    context 'given a list with zero-or-more bounds' do
      it 'generates nested list skipping code' do
        nested_code {|g| g.gen_intermediate_skip list }.
          should == (<<-CODE).strip
begin
  ep = nil
  while @scanner.skip(/w+/)
    ep = @scanner.pos
    break unless @scanner.skip(/[,;]/)
  end
  @scanner.pos = ep unless ep.nil?
  true
end
          CODE
      end
    end
  end

end
