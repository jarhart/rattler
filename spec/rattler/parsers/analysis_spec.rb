require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include Rattler::Parsers

describe Analysis do

  subject { described_class.new(grammar.rules) }

  let(:grammar) { Rattler::Parsers::Grammar[rule_set] }

  describe '#recursive?' do

    context 'given a directly recursive rule' do

      let(:rule_set) { RuleSet[
        Rule[:a, Sequence[Match[/a/], Apply[:a]]]
      ] }

      it 'returns true' do
        subject.recursive?(:a).should be_true
      end
    end

    context 'given an indirectly recursive rule' do

      let(:rule_set) { RuleSet[
        Rule[:a, Sequence[Match[/a/], Apply[:b]]],
        Rule[:b, Sequence[Match[/b/], Apply[:c]]],
        Rule[:c, Sequence[Match[/c/], Apply[:a]]]
      ] }

      it 'returns true' do
        subject.recursive?(:a).should be_true
      end
    end

    context 'given a non-recursive rule' do

      let(:rule_set) { RuleSet[
        Rule[:a, Sequence[Match[/a/], Apply[:b]]],
        Rule[:b, Sequence[Match[/b/], Apply[:c]]],
        Rule[:c, Sequence[Match[/c/], Apply[:b]]]
      ] }

      it 'returns false' do
        subject.recursive?(:a).should be_false
      end
    end

    context 'given a rule with a Super' do

      let (:rule_set) { RuleSet[
        Rule[:a, Sequence[Match[/a/], Super[:a]]]
      ] }

      it 'returns true' do
        subject.recursive?(:a).should be_true
      end
    end
  end

  describe '#left_recursive?' do

    context 'given a directly left-recursive rule' do

      let(:rule_set) { RuleSet[
        Rule[:a, Apply[:a]]
      ] }

      it 'returns true' do
        subject.left_recursive?(:a).should be_true
      end
    end

    context 'given an indirectly left-recursive rule' do

      let(:rule_set) { RuleSet[
        Rule[:a, Apply[:b]],
        Rule[:b, Apply[:c]],
        Rule[:c, Apply[:a]]
      ] }

      it 'returns true' do
        subject.left_recursive?(:a).should be_true
      end
    end

    context 'given a non-recursive rule' do

      let(:rule_set) { RuleSet[
        Rule[:a, Apply[:b]],
        Rule[:b, Apply[:c]],
        Rule[:c, Apply[:b]]
      ] }

      it 'returns false' do
        subject.left_recursive?(:a).should be_false
      end
    end

    context 'given a recursive but not left-recursive rule' do

      let(:rule_set) { RuleSet[
        Rule[:a, Sequence[Match[/a/], Apply[:a]]]
      ] }

      it 'returns false' do
        subject.left_recursive?(:a).should be_false
      end
    end
  end

end
