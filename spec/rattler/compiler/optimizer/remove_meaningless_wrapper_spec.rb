require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Compiler::Optimizer
include Rattler::Parsers

describe RemoveMeaninglessWrapper do

  let(:matching) { OptimizationContext[:type => :matching] }
  let(:capturing) { OptimizationContext[:type => :capturing] }

  describe '#apply' do
    context 'in the matching context' do

      context 'given a token parser' do

        let(:token) { Token[Sequence[Match[/a/], Match[/b/]]] }

        it 'returns the nested parser' do
          subject.apply(token, matching).should ==
            Sequence[Match[/a/], Match[/b/]]
        end
      end

      context 'given a skip parser' do

        let(:skip) { Skip[Match[/\s+/]] }

        it 'returns the nested parser' do
          subject.apply(skip, matching).should == Match[/\s+/]
        end
      end
    end
  end

  describe '#applies_to?' do

    context 'given a token parser' do

      let(:token) { Token[Sequence[Match[/a/], Match[/b/]]] }

      context 'in the matching context' do
        it 'returns true' do
          subject.applies_to?(token, matching).should be_true
        end
      end

      context 'in the capturing context' do
        it 'returns false' do
          subject.applies_to?(token, capturing).should be_false
        end
      end
    end

    context 'given a skip parser' do

      let(:skip) { Skip[Match[/\s+/]] }

      context 'in the matching context' do
        it 'returns true' do
          subject.applies_to?(skip, matching).should be_true
        end
      end

      context 'in the capturing context' do
        it 'returns false' do
          subject.applies_to?(skip, capturing).should be_false
        end
      end
    end

    context 'given another type of parser' do

      let(:predicate) { Assert[Match[/\s+/]] }

      context 'in the matching context' do
        it 'returns false' do
          subject.applies_to?(predicate, matching).should be_false
        end
      end
    end
  end
end
