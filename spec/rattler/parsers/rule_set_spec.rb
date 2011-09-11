require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rattler::Parsers::RuleSet do
  include CombinatorParserSpecHelper

  subject { RuleSet[rule_a, rule_b] }

  let(:rule_a) { Rule[:a, Match[/a/]] }
  let(:rule_b) { Rule[:b, Match[/b/]] }

  describe '#rule' do

    it 'returns rules by name' do
      subject.rule(:a).should == rule_a
      subject.rule(:b).should == rule_b
    end

    context 'with included rules' do

      subject { RuleSet[rule_a, rule_b, {:includes => [RuleSet[rule_c]]}] }

      let(:rule_c) { Rule[:c, Match[/c/]] }

      context 'given a name only in the included rules' do
        it 'returns the rule from the included rules' do
          subject.inherited_rule(:c).should == rule_c
        end
      end
    end
  end

  describe '#inherited_rule' do

    context 'with no includes' do
      it 'returns nil' do
        subject.inherited_rule(:foo).should be_nil
      end
    end

    context 'with included rules' do

      subject { RuleSet[rule_a, rule_b, {:includes => [RuleSet[old_rule_a]]}] }

      let(:old_rule_a) { Rule[:a, Match[/A/]] }

      context 'given a name not in the rule set or the included rules' do
        it 'returns nil' do
          subject.inherited_rule(:foo).should be_nil
        end
      end

      context 'given a name in the included rules' do
        it 'returns the rule from the included rules' do
          subject.inherited_rule(:a).should == old_rule_a
        end
      end
    end
  end

  describe '#[]' do

    context 'given a symbol' do
      it 'returns a rule by name' do
        subject[:a].should == rule_a
        subject[:b].should == rule_b
      end
    end

    context 'given an array argument' do
      it 'returns a rule by index' do
        subject[0].should == rule_a
        subject[1].should == rule_b
      end
    end
  end

end
