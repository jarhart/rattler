require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Compiler::Optimizer
include Rattler::Parsers

describe SimplifyRedundantRepeat do

  let(:matching) { OptimizationContext[:type => :matching] }
  let(:capturing) { OptimizationContext[:type => :capturing] }

  describe '#apply', 'given a repeat of a repeat' do

    let(:outer) { Repeat[inner, *outer_bounds] }
    let(:inner) { Repeat[match, *inner_bounds] }
    let(:match) { Match[/a/]}

    context 'where the outer repeat is zero-or-more' do

      let(:outer_bounds) { [0, nil] }

      context 'and the inner repeat is zero-or-more' do

        let(:inner_bounds) { [0, nil] }

        it 'returns a repeat with zero-or-more bounds' do
          subject.apply(outer, matching).should == Repeat[match, 0, nil]
        end
      end

      context 'and the inner repeat is one-or-more' do

        let(:inner_bounds) { [1, nil] }

        it 'returns a repeat with zero-or-more bounds' do
          subject.apply(outer, matching).should == Repeat[match, 0, nil]
        end
      end

      context 'and the inner repeat is optional' do

        let(:inner_bounds) { [0, 1] }

        it 'returns a repeat with zero-or-more bounds' do
          subject.apply(outer, matching).should == Repeat[match, 0, nil]
        end
      end
    end

    context 'where the outer repeat is one-or-more' do

      let(:outer_bounds) { [1, nil] }

      context 'and the inner repeat is zero-or-more' do

        let(:inner_bounds) { [0, nil] }

        it 'returns a repeat with zero-or-more bounds' do
          subject.apply(outer, matching).should == Repeat[match, 0, nil]
        end
      end

      context 'and the inner repeat is one-or-more' do

        let(:inner_bounds) { [1, nil] }

        it 'returns a repeat with one-or-more bounds' do
          subject.apply(outer, matching).should == Repeat[match, 1, nil]
        end
      end

      context 'and the inner repeat is optional' do

        let(:inner_bounds) { [0, 1] }

        it 'returns a repeat with zero-or-more bounds' do
          subject.apply(outer, matching).should == Repeat[match, 0, nil]
        end
      end
    end

    context 'where the outer repeat is optional' do

      let(:outer_bounds) { [0, 1] }

      context 'and the inner repeat is zero-or-more' do

        let(:inner_bounds) { [0, nil] }

        it 'returns a repeat with zero-or-more bounds' do
          subject.apply(outer, matching).should == Repeat[match, 0, nil]
        end
      end

      context 'and the inner repeat is one-or-more' do

        let(:inner_bounds) { [1, nil] }

        it 'returns a repeat with zero-or-more bounds' do
          subject.apply(outer, matching).should == Repeat[match, 0, nil]
        end
      end

      context 'and the inner repeat is optional' do

        let(:inner_bounds) { [0, 1] }

        it 'returns a repeat with optional bounds' do
          subject.apply(outer, matching).should == Repeat[match, 0, 1]
        end
      end
    end
  end

  describe '#applies_to?' do

    context 'given a repeat of a repeat' do

      let(:parser) { Repeat[Repeat[Match[/a/], *inner_bounds], 0, nil] }

      context 'in the :matching context' do

        context 'if the inner repeat has zero-or-more bounds' do

          let(:inner_bounds) { [0, nil] }

          it 'returns true' do
            subject.applies_to?(parser, matching).should be_true
          end
        end

        context 'if the inner repeat has one-or-more bounds' do

          let(:inner_bounds) { [1, nil] }

          it 'returns true' do
            subject.applies_to?(parser, matching).should be_true
          end
        end
      end

      context 'in the :capturing context' do

        let(:inner_bounds) { [0, nil] }

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
