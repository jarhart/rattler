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
