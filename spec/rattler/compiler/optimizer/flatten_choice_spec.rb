require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Parsers

describe Rattler::Compiler::Optimizer::FlattenChoice do

  describe '#apply' do

    context 'given a choice with choice terms' do

      let(:choice) { Choice[
        Match[/a/],
        Choice[Match[/b/], Match[/c/]],
        Sequence[Match[/d/], Match[/e/]]
      ] }

      it 'flattens the choice' do
        subject.apply(choice, :any).should == Choice[
          Match[/a/],
          Match[/b/],
          Match[/c/],
          Sequence[Match[/d/], Match[/e/]]
        ]
      end
    end
  end

  describe '#applies_to?' do

    context 'given a choice with choice terms' do

      let(:choice) { Choice[
        Match[/a/],
        Choice[Match[/b/], Match[/c/]],
        Sequence[Match[/d/], Match[/e/]]
      ] }

      it 'returns true' do
        subject.applies_to?(choice, :any).should be_true
      end
    end

    context 'given a choice without choice terms' do

      let(:choice) { Choice[
        Match[/a/],
        Match[/b/],
        Sequence[Match[/c/], Match[/d/]]
      ] }

      it 'returns false' do
        subject.applies_to?(choice, :any).should be_false
      end
    end

    context 'given something other than a choie' do

      let(:choice) { Sequence[
        Match[/a/],
        Choice[Match[/b/], Match[/c/]],
        Sequence[Match[/d/], Match[/e/]]
      ] }

      it 'returns false' do
        subject.applies_to?(choice, :any).should be_false
      end
    end
  end

end
