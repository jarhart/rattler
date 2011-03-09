require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Parsers

describe Rattler::BackEnd::Optimizer::JoinMatchChoice do

  describe '#apply' do

    context 'given a choice of all matches' do

      let(:choice) { Choice[Match[/a/], Match[/b/], Match[/c/]] }

      it 'joins them into a single match' do
        subject.apply(choice, :any).should == Match[/a|b|c/]
      end
    end

    context 'given a choice of matches followed by something else' do

      let(:choice) { Choice[Match[/a/], Match[/b/], Apply[:c]] }

      it 'joins the consecutive matches into a single match' do
        subject.apply(choice, :any).should == Choice[
          Match[/a|b/],
          Apply[:c]
        ]
      end
    end

    context 'given a choice of matches following something else' do

      let(:choice) { Choice[Apply[:a], Match[/b/], Match[/c/]] }

      it 'joins the consecutive matches into a single match' do
        subject.apply(choice, :any).should == Choice[
          Apply[:a],
          Match[/b|c/]
        ]
      end
    end
  end

  describe '#applies_to?' do

    context 'given a choice of all matches' do

      let(:choice) { Choice[Match[/a/], Match[/b/], Match[/c/]] }

      it 'returns true' do
        subject.applies_to?(choice, :any).should be_true
      end
    end

    context 'given a choice of matches followed by something else' do

      let(:choice) { Choice[Match[/a/], Match[/b/], Apply[:c]] }

      it 'returns true' do
        subject.applies_to?(choice, :any).should be_true
      end
    end

    context 'given a choice of matches following something else' do

      let(:choice) { Choice[Apply[:a], Match[/b/], Match[/c/]] }

      it 'returns true' do
        subject.applies_to?(choice, :any).should be_true
      end
    end

    context 'given a choice with only one match' do

      let(:choice) { Choice[Apply[:a], Match[/b/], Apply[:c]] }

      it 'returns true' do
        subject.applies_to?(choice, :any).should be_false
      end
    end

    context 'given a choice of non-consecutive matches' do

      let(:choice) { Choice[Match[/a/], Apply[:b], Match[/c/]] }

      it 'returns false' do
        subject.applies_to?(choice, :any).should be_false
      end
    end

    context 'given a non-choice' do

      let(:sequence) { Sequence[Match[/a/], Match[/b/], Match[/c/]] }

      it 'returns false' do
        subject.applies_to?(sequence, :any).should be_false
      end
    end
  end

end
