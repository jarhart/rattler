require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::Optimizer
include Rattler::Parsers

describe ReduceRepeatMatch do

  let(:matching) { OptimizationContext[:type => :matching] }
  let(:capturing) { OptimizationContext[:type => :capturing] }

  describe '#apply' do

    context 'given a zero-or-more match' do

      let(:repeat) { ZeroOrMore[Match[/a/]] }

      it 'converts it to an equivalent match' do
        subject.apply(repeat, matching).should == Match[/(?>a)*/]
      end
    end

    context 'given a one-or-more of a match' do

      let(:repeat) { OneOrMore[Match[/a/]] }

      it 'converts it to an equivalent match' do
        subject.apply(repeat, matching).should == Match[/(?>a)+/]
      end
    end

    context 'given an optional match' do

      let(:repeat) { Optional[Match[/a/]] }

      it 'converts it to an equivalent match' do
        subject.apply(repeat, matching).should == Match[/(?>a)?/]
      end
    end

    context 'given a repeat match' do

      let(:repeat) { Repeat[Match[/a/], 2, 4] }

      it 'converts it to an equivalent match' do
        subject.apply(repeat, matching).should == Match[/(?>a){2,4}/]
      end

      context 'with no upper bound' do
        let(:repeat) { Repeat[Match[/a/], 2, nil] }

        it 'converts it to an equivalent match' do
          subject.apply(repeat, matching).should == Match[/(?>a){2,}/]
        end
      end

      context 'with equal bounds' do
        let(:repeat) { Repeat[Match[/a/], 3, 3] }

        it 'converts it to an equivalent match' do
          subject.apply(repeat, matching).should == Match[/(?>a){3}/]
        end
      end
    end
  end

  describe '#applies_to?' do

    context 'in the :capturing context' do

      let(:repeat) { ZeroOrMore[Match[/a/]] }

      it 'returns false' do
        subject.applies_to?(repeat, capturing).should be_false
      end
    end

    context 'given a zero-or-more of a match' do

      let(:repeat) { ZeroOrMore[Match[/a/]] }

      it 'returns true' do
        subject.applies_to?(repeat, matching).should be_true
      end
    end

    context 'given a one-or-more of a match' do

      let(:repeat) { OneOrMore[Match[/a/]] }

      it 'returns true' do
        subject.applies_to?(repeat, matching).should be_true
      end
    end

    context 'given an optional match' do

      let(:repeat) { Optional[Match[/a/]] }

      it 'returns true' do
        subject.applies_to?(repeat, matching).should be_true
      end
    end

    context 'given an optional match' do

      let(:repeat) { Repeat[Match[/a/], 2, 4] }

      it 'returns true' do
        subject.applies_to?(repeat, matching).should be_true
      end
    end

    context 'given a repeat of something other than a match' do

      let(:repeat) { ZeroOrMore[Apply[:a]] }

      it 'returns false' do
        subject.applies_to?(repeat, matching).should be_false
      end
    end

    context 'given something other than a repeat' do

      let(:other) { Assert[Match[/a/]] }

      it 'returns false' do
        subject.applies_to?(other, matching).should be_false
      end
    end
  end

end
