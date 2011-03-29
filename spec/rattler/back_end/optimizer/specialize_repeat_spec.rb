require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::Optimizer
include Rattler::Parsers

describe SpecializeRepeat do

  let(:parser) { Repeat[child, *bounds]}
  let(:child) { Match[/w/] }

  describe '#apply given a repeat' do

    context 'with optional bounds' do
      let(:bounds) { [0, 1] }

      it 'returns an Optional' do
        subject.apply(parser, :any).should == Optional[child]
      end
    end

    context 'with zero_or_more bounds' do
      let(:bounds) { [0, nil] }

      it 'returns a ZeroOrMore' do
        subject.apply(parser, :any).should == ZeroOrMore[child]
      end
    end

    context 'with one_or_more bounds' do
      let(:bounds) { [1, nil] }

      it 'returns a OneOrMore' do
        subject.apply(parser, :any).should == OneOrMore[child]
      end
    end
  end

  describe '#applies_to?' do

    context 'given a repeat' do

      let(:parser) { Repeat[child, *bounds]}

      context 'with optional bounds' do
        let(:bounds) { [0, 1] }

        it 'returns true' do
          subject.applies_to?(parser, :any).should be_true
        end
      end

      context 'with zero_or_more bounds' do
        let(:bounds) { [0, nil] }

        it 'returns true' do
          subject.applies_to?(parser, :any).should be_true
        end
      end

      context 'with one_or_more bounds' do
        let(:bounds) { [1, nil] }

        it 'returns true' do
          subject.applies_to?(parser, :any).should be_true
        end
      end

      context 'with any other bounds' do
        let(:bounds) { [2, nil] }

        it 'returns false' do
          subject.applies_to?(parser, :any).should be_false
        end
      end
    end

    context 'given something other than a repeat' do

      let(:parser) { Match[/w/] }

      it 'returns false' do
        subject.applies_to?(parser, :any).should be_false
      end
    end
  end
end
