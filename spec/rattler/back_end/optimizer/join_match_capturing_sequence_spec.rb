require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::Optimizer
include Rattler::Parsers
include Rattler::BackEnd::ParserGenerator

describe JoinMatchCapturingSequence do

  let(:capturing) { OptimizationContext[:type => :capturing] }
  let(:matching) { OptimizationContext[:type => :matching] }

  describe '#apply' do

    context 'given a sequence of all skipping matches' do

      let(:sequence) { Sequence[
        Skip[Match[/a/]],
        Skip[Match[/b/]],
        Skip[Match[/c/]]
      ] }

      it 'joins them into a single skipping match' do
        subject.apply(sequence, capturing).
        should == Skip[Match[/(?>a)(?>b)(?>c)/]]
      end
    end

    context 'given a sequence of skipping matches followed by something else' do

      let(:sequence) { Sequence[
        Skip[Match[/a/]],
        Skip[Match[/b/]],
        Apply[:c]
      ] }

      it 'joins the consecutive skipping matches into a single match' do
        subject.apply(sequence, capturing).should == Sequence[
          Skip[Match[/(?>a)(?>b)/]],
          Apply[:c]
        ]
      end
    end

    context 'given a sequence of skipping matches following something else' do

      let(:sequence) { Sequence[
        Apply[:a],
        Skip[Match[/b/]],
        Skip[Match[/c/]]
      ] }

      it 'joins the consecutive skipping matches into a single match' do
        subject.apply(sequence, capturing).should == Sequence[
          Apply[:a],
          Skip[Match[/(?>b)(?>c)/]]
        ]
      end
    end

    context 'given a sequence of matches' do

      let(:sequence) { Sequence[
        Match[/a/],
        Match[/b/],
        Match[/c/]
      ] }

      it 'joins them into a single group match' do
        subject.apply(sequence, capturing).
        should == GroupMatch[Match[/(a)(b)(c)/], {:num_groups => 3}]
      end
    end

    context 'given a sequence of single-group matches' do

      let(:sequence) { Sequence[
        GroupMatch[Match[/\s*(a)/], {:num_groups => 1}],
        GroupMatch[Match[/\s*(b)/], {:num_groups => 1}],
        GroupMatch[Match[/\s*(c)/], {:num_groups => 1}]
      ] }

      it 'joins them into a single group match' do
        subject.apply(sequence, capturing).
        should == GroupMatch[Match[/(?>\s*(a))(?>\s*(b))(?>\s*(c))/], {:num_groups => 3}]
      end
    end

    context 'give a mix of bare and single-group matches' do

      let(:sequence) { Sequence[
        GroupMatch[Match[/\s*(a)/], {:num_groups => 1}],
        Match[/[+\-*\/]/],
        GroupMatch[Match[/\s*(b)/], {:num_groups => 1}],
      ] }

      it 'joins them into a single group match' do
        subject.apply(sequence, capturing).
        should == GroupMatch[Match[/(?>\s*(a))([+\-*\/])(?>\s*(b))/], {:num_groups => 3}]
      end
    end
  end

  describe '#applies_to?' do

    context 'given a sequence of matches followed by something else' do

      let(:sequence) { Sequence[
        Match[/a/],
        Match[/b/],
        Apply[:c]
      ] }

      it 'returns true' do
        subject.applies_to?(sequence, capturing).should be_true
      end
    end

    context 'given a sequence of matches following something else' do

      let(:sequence) { Sequence[
        Apply[:a],
        Match[/b/],
        Match[/c/]
      ] }

      it 'returns true' do
        subject.applies_to?(sequence, capturing).should be_true
      end
    end

    context 'given a sequence of skipping matches followed by something else' do

      let(:sequence) { Sequence[
        Skip[Match[/a/]],
        Skip[Match[/b/]],
        Apply[:c]
      ] }

      it 'returns true' do
        subject.applies_to?(sequence, capturing).should be_true
      end
    end

    context 'given a sequence of skipping matches following something else' do

      let(:sequence) { Sequence[
        Apply[:a],
        Skip[Match[/b/]],
        Skip[Match[/c/]]
      ] }

      it 'returns true' do
        subject.applies_to?(sequence, capturing).should be_true
      end
    end

    context 'given a sequence of single-group matches followed by something else' do

      let(:sequence) { Sequence[
        GroupMatch[Match[/a/], {:num_groups => 1}],
        GroupMatch[Match[/b/], {:num_groups => 1}],
        Apply[:c]
      ] }

      it 'returns true' do
        subject.applies_to?(sequence, capturing).should be_true
      end
    end

    context 'given a sequence of single-group matches following something else' do

      let(:sequence) { Sequence[
        Apply[:a],
        GroupMatch[Match[/b/], {:num_groups => 1}],
        GroupMatch[Match[/c/], {:num_groups => 1}]
      ] }

      it 'returns true' do
        subject.applies_to?(sequence, capturing).should be_true
      end
    end

    context 'given a sequence of multi-group matches followed by something else' do

      let(:sequence) { Sequence[
        GroupMatch[Match[/a/], {:num_groups => 2}],
        GroupMatch[Match[/b/], {:num_groups => 2}],
        Apply[:c]
      ] }

      it 'returns false' do
        subject.applies_to?(sequence, capturing).should be_false
      end
    end

    context 'given a sequence of multi-group matches following something else' do

      let(:sequence) { Sequence[
        Apply[:a],
        GroupMatch[Match[/b/], {:num_groups => 2}],
        GroupMatch[Match[/c/], {:num_groups => 2}]
      ] }

      it 'returns false' do
        subject.applies_to?(sequence, capturing).should be_false
      end
    end

    context 'given a sequence with only one match' do

      let(:sequence) { Sequence[Apply[:a], Skip[Match[/b/]], Apply[:c]] }

      it 'returns false' do
        subject.applies_to?(sequence, capturing).should be_false
      end
    end

    context 'given a sequence of non-consecutive matches' do

      let(:sequence) { Sequence[Skip[Match[/a/]], Apply[:b], Skip[Match[/c/]]] }

      it 'returns false' do
        subject.applies_to?(sequence, capturing).should be_false
      end
    end

    context 'given a non-sequence' do

      let(:parser) { Choice[
        Skip[Match[/a/]],
        Skip[Match[/b/]],
        Skip[Match[/c/]]
      ] }

      it 'returns false' do
        subject.applies_to?(parser, capturing).should be_false
      end
    end
  end

end
