require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::Optimizer
include Rattler::Parsers

describe JoinMatchSequence do

  let(:matching) { OptimizationContext[:type => :matching] }
  let(:capturing) { OptimizationContext[:type => :capturing] }

  describe '#apply' do

    context 'given a sequence of all matches' do

      let(:sequence) { Sequence[Match[/a/], Match[/b/], Match[/c/]] }

      it 'joins them into a single match' do
        subject.apply(sequence, matching).should == Match[/(?>a)(?>b)(?>c)/]
      end
    end

    context 'given a sequence of matches followed by something else' do

      let(:sequence) { Sequence[Match[/a/], Match[/b/], Apply[:c]] }

      it 'joins the consecutive matches into a single match' do
        subject.apply(sequence, matching).should == Sequence[
          Match[/(?>a)(?>b)/],
          Apply[:c]
        ]
      end
    end

    context 'given a sequence of matches following something else' do

      let(:sequence) { Sequence[Apply[:a], Match[/b/], Match[/c/]] }

      it 'joins the consecutive matches into a single match' do
        subject.apply(sequence, matching).should == Sequence[
          Apply[:a],
          Match[/(?>b)(?>c)/]
        ]
      end
    end
  end

  describe '#applies_to?' do

    context 'given a sequence of all matches' do

      let(:sequence) { Sequence[Match[/a/], Match[/b/], Match[/c/]] }

      context 'in the :matching context' do
        it 'returns true' do
          subject.applies_to?(sequence, matching).should be_true
        end
      end

      context 'in the :matching context' do
        it 'returns true' do
          subject.applies_to?(sequence, capturing).should be_true
        end
      end
    end

    context 'given a sequence of matches followed by something else' do

      let(:sequence) { Sequence[Match[/a/], Match[/b/], Apply[:c]] }

      it 'returns true' do
        subject.applies_to?(sequence, matching).should be_true
      end
    end

    context 'given a sequence of matches following something else' do

      let(:sequence) { Sequence[Apply[:a], Match[/b/], Match[/c/]] }

      it 'returns true' do
        subject.applies_to?(sequence, matching).should be_true
      end
    end

    context 'given a sequence with only one match' do

      let(:sequence) { Sequence[Apply[:a], Match[/b/], Apply[:c]] }

      it 'returns true' do
        subject.applies_to?(sequence, matching).should be_false
      end
    end

    context 'given a sequence of non-consecutive matches' do

      let(:sequence) { Sequence[Match[/a/], Apply[:b], Match[/c/]] }

      it 'returns false' do
        subject.applies_to?(sequence, matching).should be_false
      end
    end

    context 'given a non-sequence' do

      let(:choice) { Choice[Match[/a/], Match[/b/], Match[/c/]] }

      it 'returns false' do
        subject.applies_to?(choice, matching).should be_false
      end
    end
  end

end
