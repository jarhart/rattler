require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Compiler::Optimizer
include Rattler::Parsers

describe InlineRegularRules do

  let(:context) { OptimizationContext[
    :type => :capturing,
    :rules => rule_set
  ] }

  let(:rule_set) { RuleSet[rule_a, {:start_rule => :a}] }

  describe '#apply' do

    context 'given a reference to a regular rule' do

      let(:rule_a) { Rule[:a, Match[/a/], {:inline => true}] }

      it 'inlines the regular rule' do
        subject.apply(Apply[:a], context).should == Match[/a/]
      end
    end
  end

  describe '#_applies_to?' do

    context 'given a reference to a regular rule' do

      context 'tagged as :inline' do

        let(:rule_a) { Rule[:a, Match[/a/], {:inline => true}] }

        it 'returns true' do
          subject.applies_to?(Apply[:a], context).should be_true
        end
      end

      context 'not tagged as :inline' do

        let(:rule_a) { Rule[:a, Match[/a/]] }

        it 'returns false' do
          subject.applies_to?(Apply[:a], context).should be_false
        end
      end
    end
  end
end
