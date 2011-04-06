require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

shared_examples_for 'an optional generator' do

  let(:bounds) { [0, 1] }
  let(:nested) { Match[/w+/] }

  describe '#gen_basic' do

    context 'given a repeat with optional bounds' do

      context 'when nested' do
        it 'generates nested optional matching code' do
          nested_code {|g| g.gen_basic repeat }.
            should == '((r = @scanner.scan(/w+/)) ? [r] : [])'
        end
      end

      context 'when top-level' do
        it 'generates top level optional matching code' do
          top_level_code {|g| g.gen_basic repeat }.
            should == '(r = @scanner.scan(/w+/)) ? [r] : []'
        end
      end
    end
  end

  describe '#gen_assert' do

    context 'given a repeat with optional bounds' do

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

    context 'given a repeat with optional bounds' do

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

    context 'given a repeat with optional bounds' do

      context 'when nested' do
        it 'generates nested optional matching code with a dispatch action' do
          nested_code {|g| g.gen_dispatch_action repeat, code }.
            should == (<<-CODE).strip
begin
  r = @scanner.scan(/w+/)
  Word.parsed(r ? [r] : [])
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top level optional matching code with a dispatch action' do
          top_level_code {|g| g.gen_dispatch_action repeat, code }.
            should == (<<-CODE).strip
r = @scanner.scan(/w+/)
Word.parsed(r ? [r] : [])
            CODE
        end
      end
    end
  end

  describe '#gen_direct_action' do

    let(:nested) { Match[/w+/] }
    let(:code) { ActionCode.new('|_| _.size') }

    context 'given a repeat with optional bounds' do

      context 'when nested' do
        it 'generates nested optional matching code with a direct action' do
          nested_code {|g| g.gen_direct_action repeat, code }.
            should == (<<-CODE).strip
begin
  r = @scanner.scan(/w+/)
  ((r ? [r] : []).size)
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top level optional matching code with a direct action' do
          top_level_code {|g| g.gen_direct_action repeat, code }.
            should == (<<-CODE).strip
r = @scanner.scan(/w+/)
((r ? [r] : []).size)
            CODE
        end
      end
    end
  end

  describe '#gen_token' do

    let(:nested) { Match[/w+/] }

    context 'given a repeat with optional bounds' do

      context 'when nested' do
        it 'generates nested optional matching code' do
          nested_code {|g| g.gen_token repeat }.
            should == (<<-CODE).strip
begin
  @scanner.scan(/w+/) || ''
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top level optional matching code' do
          top_level_code {|g| g.gen_token repeat }.
            should == "@scanner.scan(/w+/) || ''"
        end
      end
    end
  end

  describe '#gen_skip' do

    let(:nested) { Match[/w+/] }

    context 'given a repeat with optional bounds' do

      context 'when nested' do
        it 'generates nested optional skipping code' do
          nested_code {|g| g.gen_skip repeat }.
            should == (<<-CODE).strip
begin
  @scanner.skip(/w+/)
  true
end
            CODE
        end
      end

      context 'when top-level' do
        it 'generates top level optional skipping code' do
          top_level_code {|g| g.gen_skip repeat }.
            should == (<<-CODE).strip
@scanner.skip(/w+/)
true
            CODE
        end
      end
    end
  end

  describe '#gen_intermediate' do

    let(:nested) { Match[/w+/] }

    context 'given a repeat with optional bounds' do
      it 'generates nested optional matching code' do
        nested_code {|g| g.gen_intermediate repeat }.
          should == '((r = @scanner.scan(/w+/)) ? [r] : [])'
      end
    end
  end

  describe '#gen_intermediate_assert' do

    let(:nested) { Match[/w+/] }

    context 'given a repeat with optional bounds' do
      it 'generates "true"' do
        nested_code {|g| g.gen_intermediate_assert repeat }.should == 'true'
      end
    end
  end

  describe '#gen_intermediate_disallow' do

    let(:nested) { Match[/w+/] }

    context 'given a repeat with optional bounds' do
      it 'generates "false"' do
        nested_code {|g| g.gen_intermediate_disallow repeat }.should == 'false'
      end
    end
  end

  describe '#gen_intermediate_skip' do

    let(:nested) { Match[/w+/] }

    context 'given a repeat with optional bounds' do
      it 'generates nested optional skipping code' do
        nested_code {|g| g.gen_intermediate_skip repeat }.
          should == (<<-CODE).strip
begin
  @scanner.skip(/w+/)
  true
end
          CODE
      end
    end
  end

end
