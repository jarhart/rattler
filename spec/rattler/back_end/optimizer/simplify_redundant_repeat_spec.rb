require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::Optimizer
include Rattler::Parsers

describe SimplifyRedundantRepeat do

  let(:matching) { OptimizationContext[:type => :matching] }
  let(:capturing) { OptimizationContext[:type => :capturing] }

  describe '#apply' do

    context 'given a zero-or-more' do

      let(:parser) { ZeroOrMore[child] }

      context 'with a zero-or-more' do

        let(:child) { ZeroOrMore[Match[/a/]] }

        it 'returns the inner ZeroOrMore' do
          subject.apply(parser, matching).should == ZeroOrMore[Match[/a/]]
        end
      end

      context 'with a one-or-more' do

        let(:child) { OneOrMore[Match[/a/]] }

        it 'returns a ZeroOrMore' do
          subject.apply(parser, matching).should == ZeroOrMore[Match[/a/]]
        end
      end

      context 'with an optional' do

        let(:child) { Optional[Match[/a/]] }

        it 'returns a ZeroOrMore' do
          subject.apply(parser, matching).should == ZeroOrMore[Match[/a/]]
        end
      end
    end

    context 'given a one-or-more' do

      let(:parser) { OneOrMore[child] }

      context 'with a zero-or-more' do

        let(:child) { ZeroOrMore[Match[/a/]] }

        it 'returns the inner ZeroOrMore' do
          subject.apply(parser, matching).should == ZeroOrMore[Match[/a/]]
        end
      end

      context 'with a one-or-more' do

        let(:child) { OneOrMore[Match[/a/]] }

        it 'returns the inner OneOrMore' do
          subject.apply(parser, matching).should == OneOrMore[Match[/a/]]
        end
      end

      context 'with an optional' do

        let(:child) { Optional[Match[/a/]] }

        it 'returns a ZeroOrMore' do
          subject.apply(parser, matching).should == ZeroOrMore[Match[/a/]]
        end
      end
    end

    context 'given an optional' do

      let(:parser) { Optional[child] }

      context 'with a zero-or-more' do

        let(:child) { ZeroOrMore[Match[/a/]] }

        it 'returns the inner ZeroOrMore' do
          subject.apply(parser, matching).should == ZeroOrMore[Match[/a/]]
        end
      end

      context 'with a one-or-more' do

        let(:child) { OneOrMore[Match[/a/]] }

        it 'returns a ZeroOrMore' do
          subject.apply(parser, matching).should == ZeroOrMore[Match[/a/]]
        end
      end

      context 'with an optional' do

        let(:child) { Optional[Match[/a/]] }

        it 'returns the inner Optional' do
          subject.apply(parser, matching).should == Optional[Match[/a/]]
        end
      end
    end
  end

  describe '#applies_to?' do

    context 'given a zero-or-more' do

      let(:parser) { ZeroOrMore[child] }

      context 'with a zero-or-more' do

        let(:child) { ZeroOrMore[Match[/a/]] }

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

      context 'with something other than a repeat' do

        let(:child) { Match[/a/] }

        it 'returns false' do
          subject.applies_to?(parser, matching).should be_false
        end
      end

      context 'with a one-or-more' do

        let(:child) { OneOrMore[Match[/a/]] }

        it 'returns true' do
          subject.applies_to?(parser, matching).should be_true
        end
      end

      context 'with an optional' do

        let(:child) { Optional[Match[/a/]] }

        it 'returns true' do
          subject.applies_to?(parser, matching).should be_true
        end
      end
    end

    context 'given a one-or-more' do

      let(:parser) { OneOrMore[child] }

      context 'with a zero-or-more' do

        let(:child) { ZeroOrMore[Match[/a/]] }

        it 'returns true' do
          subject.applies_to?(parser, matching).should be_true
        end
      end

      context 'with a one-or-more' do

        let(:child) { OneOrMore[Match[/a/]] }

        it 'returns true' do
          subject.applies_to?(parser, matching).should be_true
        end
      end

      context 'with an optional' do

        let(:child) { Optional[Match[/a/]] }

        it 'returns true' do
          subject.applies_to?(parser, matching).should be_true
        end
      end
    end

    context 'given an optional' do

      let(:parser) { Optional[child] }

      context 'with a zero-or-more' do

        let(:child) { ZeroOrMore[Match[/a/]] }

        it 'returns true' do
          subject.applies_to?(parser, matching).should be_true
        end
      end

      context 'with a one-or-more' do

        let(:child) { OneOrMore[Match[/a/]] }

        it 'returns true' do
          subject.applies_to?(parser, matching).should be_true
        end
      end

      context 'with an optional' do

        let(:child) { Optional[Match[/a/]] }

        it 'returns true' do
          subject.applies_to?(parser, matching).should be_true
        end
      end
    end
  end

end
