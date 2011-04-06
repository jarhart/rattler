require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::Optimizer
include Rattler::Parsers

describe SimplifyRedundantRepeat do

  let(:matching) { OptimizationContext[:type => :matching] }
  let(:capturing) { OptimizationContext[:type => :capturing] }

  describe '#apply' do

    let(:outer) { Repeat[inner, *outer_bounds] }
    let(:inner) { Repeat[match, *inner_bounds] }
    let(:match) { Match[/a/]}

    context 'given a repeat with one-or-more bounds of a repeat with one-or-more bounds' do

      let(:outer_bounds) { [1, nil] }
      let(:inner_bounds) { [1, nil] }

      it 'returns a repeat with one-or-more bounds' do
        subject.apply(outer, matching).should == Repeat[match, 1, nil]
      end
    end

    context 'given a repeat with optional bounds of a repeat with optional bounds' do

      let(:outer_bounds) { [0, 1] }
      let(:inner_bounds) { [0, 1] }

      it 'returns a repeat with one-or-more bounds' do
        subject.apply(outer, matching).should == Repeat[match, 0, 1]
      end
    end

    context 'given a repeat with zero-or-more bounds of a repeat' do

      let(:outer_bounds) { [0, nil] }
      let(:inner_bounds) { [1, nil] }

      it 'returns a repeat with zero-or-more bounds' do
        subject.apply(outer, matching).should == Repeat[match, 0, nil]
      end
    end
  end

  describe '#applies_to?' do

    context 'given a repeat of a repeat' do

      let(:parser) { Repeat[Repeat[Match[/a/], 1, nil], 0, nil] }

      context 'in the :matching context' do
        it 'returns true' do
          subject.applies_to?(parser, matching).should be_true
        end
      end

      context 'in the :capturing context' do
        it 'returns false' do
          subject.applies_to?(parser, capturing).should be_false
        end
      end
    end

    context 'given a repeat of something other than a repeat' do

      let(:parser) { Repeat[Match[/a/], 2, 4] }

      it 'returns false' do
        subject.applies_to?(parser, capturing).should be_false
      end
    end

    context 'given something other than a repeat' do

      let(:parser) { Match[/a/] }

      it 'returns false' do
        subject.applies_to?(parser, capturing).should be_false
      end
    end
  end

end
