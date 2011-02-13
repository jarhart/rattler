require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include Rattler::Parsers

describe Rattler::Grammar::Grammar do
  
  let(:rules) { Rules[
    Rule[:a, Choice[
      Match['a'],
      Apply[:b]
    ]],
    Rule[:b, Match['b']]
  ] }
  
  describe '#start_rule' do
    context 'when no start_rule option was specified' do
      
      subject { Rattler::Grammar::Grammar.new(rules) }
      
      it 'returns the name of the first rule' do
        subject.start_rule.should == :a
      end
    end
    
    context 'when an explicit start_rule option was specified' do
      
      subject { Rattler::Grammar::Grammar.new(rules, :start_rule => :b) }
      
      it 'uses the specified start_rule option' do
        subject.start_rule.should == :b
      end
    end
  end
  
  describe '#rules' do
    context 'when no start_rule option was specified' do
      
      subject { Rattler::Grammar::Grammar.new(rules) }
      
      it 'returns rules with the default start_rule' do
        subject.rules.start_rule.should == :a
      end
    end
    
    context 'when an explicit start_rule option was specified' do
      
      subject { Rattler::Grammar::Grammar.new(rules, :start_rule => :b) }
      
      it 'returns rules with the specified start_rule option' do
        subject.rules.start_rule.should == :b
      end
    end
  end
  
end