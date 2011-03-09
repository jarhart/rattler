require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::Optimizer
include Rattler::Parsers

describe FlattenSequence do

  let(:matching) { OptimizationContext[:type => :matching] }
  let(:capturing) { OptimizationContext[:type => :capturing] }

  describe '#apply' do

    context 'in the matching context' do

      context 'given a sequence with sequence terms' do

        let(:sequence) { Sequence[
          Match[/a/],
          Sequence[Match[/b/], Match[/c/]],
          Choice[Match[/c/], Match[/d/]]
        ] }

        it 'flattens the sequence' do
          subject.apply(sequence, matching).should == Sequence[
            Match[/a/],
            Match[/b/],
            Match[/c/],
            Choice[Match[/c/], Match[/d/]],
          ]
        end
      end
    end

    context 'in the capturing context' do

      context 'given a sequence with single-capturing sequence terms' do

        let(:sequence) { Sequence[
          Match[/a/],
          Sequence[Skip[Match[/b/]], Skip[Match[/c/]]],
          Sequence[Match[/b/], Skip[Match[/c/]]]
        ] }

        it 'flattens the sequences' do
          subject.apply(sequence, capturing).should == Sequence[
            Match[/a/],
            Skip[Match[/b/]],
            Skip[Match[/c/]],
            Match[/b/],
            Skip[Match[/c/]]
          ]
        end
      end

      context 'given a sequence with multi-capturing sequence terms' do

        let(:sequence) { Sequence[
          Match[/a/],
          Sequence[Skip[Match[/b/]], Skip[Match[/c/]]],
          Sequence[Match[/b/], Match[/c/]]
        ] }

        it 'avoids flattening the capturing sequences' do
          subject.apply(sequence, capturing).should == Sequence[
            Match[/a/],
            Skip[Match[/b/]],
            Skip[Match[/c/]],
            Sequence[Match[/b/], Match[/c/]]
          ]
        end
      end
    end

  end

  describe '#applies_to?' do

    context 'given a sequence with only capturing sequence terms' do

      let(:sequence) { Sequence[
        Match[/a/],
        Sequence[Match[/b/], Match[/c/]],
        Choice[Match[/c/], Match[/d/]]
      ] }

      context 'in the matching context' do
        it 'returns true' do
          subject.applies_to?(sequence, matching).should be_true
        end
      end

      context 'in the capturing context' do
        it 'returns false' do
          subject.applies_to?(sequence, capturing).should be_false
        end
      end
    end

    context 'given a sequence with non-capturing sequence terms' do

      let(:sequence) { Sequence[
        Match[/a/],
        Sequence[Skip[Match[/b/]], Skip[Match[/c/]]],
        Choice[Match[/c/], Match[/d/]]
      ] }

      context 'in the capturing context' do
        it 'returns true' do
          subject.applies_to?(sequence, capturing).should be_true
        end
      end
    end

    context 'given a sequence with single-capturing sequence terms' do

      let(:sequence) { Sequence[
        Match[/a/],
        Sequence[Skip[Match[/b/]], Skip[Match[/c/]]],
        Sequence[Match[/b/], Skip[Match[/c/]]]
      ] }

      context 'in the capturing context' do
        it 'returns true' do
          subject.applies_to?(sequence, capturing).should be_true
        end
      end
    end
  end

end
