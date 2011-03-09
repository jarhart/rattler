require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include Rattler::Parsers

describe Rattler::Grammar::Analysis do

  subject { described_class.new(grammar.rules) }

  let(:grammar) { Rattler::Grammar::Grammar[rule_set] }

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

  describe '#referenced_from?' do

    context 'with non-recursive rules' do

      let(:rule_set) { RuleSet[
        Rule[:a, Apply[:b]],
        Rule[:b, Apply[:c]],
        Rule[:c, Match[/a/]],
        Rule[:d, Match[/b/]]
      ] }

      context 'given a rule name and itself' do
        it 'returns false' do
          subject.referenced_from?(:a, :a).should be_false
        end
      end

      context 'given a directly referenced rule name' do
        it 'returns true' do
          subject.referenced_from?(:a, :b).should be_true
        end
      end

      context 'given an indirectly referenced rule name' do
        it 'returns true' do
          subject.referenced_from?(:a, :c).should be_true
        end
      end

      context 'given a non-referenced rule name' do
        it 'returns false' do
          subject.referenced_from?(:a, :d).should be_false
        end
      end
    end

    context 'with recursive rules' do

      let(:rule_set) { RuleSet[
        Rule[:a, Apply[:a]],
        Rule[:b, Apply[:c]],
        Rule[:c, Apply[:b]]
      ] }

      context 'given a directly recursive rule name and itself' do
        it 'returns true' do
          subject.referenced_from?(:a, :a).should be_true
        end
      end

      context 'given an indirectly recursive rule name and itself' do
        it 'returns true' do
          subject.referenced_from?(:b, :b).should be_true
        end
      end

      context 'given a referenced rule name' do
        it 'returns true' do
          subject.referenced_from?(:b, :c).should be_true
        end
      end
    end

  end

end
