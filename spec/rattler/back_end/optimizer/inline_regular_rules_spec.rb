require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::Optimizer
include Rattler::Parsers

describe InlineRegularRules do

  let(:standalone) { OptimizationContext[
    :type => :capturing,
    :rules => rule_set,
    :standalone => true
  ] }

  let(:modular) { OptimizationContext[
    :type => :capturing,
    :rules => rule_set
  ] }

  let(:rule_set) { RuleSet[rule_a, {:start_rule => :a}] }

  describe '#apply' do

    context 'given a reference to a regular rule' do

      let(:rule_a) { Rule[:a, Match[/a/]] }

      it 'inlines the regular rule' do
        subject.apply(Apply[:a], standalone).should == Match[/a/]
      end
    end
  end

  describe '#_applies_to?' do

    context 'with the :standalone option set' do

      context 'given a reference to a regular rule' do

        let(:rule_a) { Rule[:a, Match[/a/]] }

        it 'returns true' do
          subject.applies_to?(Apply[:a], standalone).should be_true
        end
      end

      context 'given a reference to a recursive rule' do

        let(:rule_a) { Rule[:a, Sequence[Match[/a/], Apply[:a]]] }

        it 'returns false' do
          subject.applies_to?(Apply[:a], standalone).should be_false
        end
      end

      context 'given a reference to a rule with a Super' do

        let(:rule_a) { Rule[:a, Sequence[Match[/a/], Super[:a]]] }

        it 'returns false' do
          subject.applies_to?(Apply[:a], standalone).should be_false
        end
      end
    end

    context 'without the :standalone option set' do

      context 'given a reference to a regular rule' do

        context 'tagged as :inline' do

          let(:rule_a) { Rule[:a, Match[/a/], {:inline => true}] }

          it 'returns true' do
            subject.applies_to?(Apply[:a], modular).should be_true
          end
        end

        context 'not tagged as :inline' do

          let(:rule_a) { Rule[:a, Match[/a/]] }

          it 'returns false' do
            subject.applies_to?(Apply[:a], modular).should be_false
          end
        end
      end
    end
  end
end
