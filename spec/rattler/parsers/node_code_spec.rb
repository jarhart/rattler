require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rattler::Parsers::NodeCode do

  subject { described_class.new(target_name, method_name) }

  let(:target_name) { 'Expr' }
  let(:method_name) { 'parsed' }

  describe '#bind' do

    let(:scope) { {} }

    context 'given empty bind args' do
      it 'binds "[]"' do
        subject.bind(scope, []).should == 'Expr.parsed([])'
      end
    end

    context 'given a single bind arg' do
      it 'binds the an array with the arg' do
        subject.bind(scope, ['a']).should == 'Expr.parsed([a])'
      end
    end

    context 'given a multiple bind args' do
      it 'binds the an array with the arg' do
        subject.bind(scope, ['a', 'b', 'c']).should == 'Expr.parsed([a, b, c])'
      end
    end

    context 'given a string as bind args' do
      it 'binds the exact string' do
        subject.bind(scope, 'a').should == 'Expr.parsed(a)'
      end
    end

    context 'with scope' do

      let(:scope) { {:word => 'w'} }

      it 'binds the scope as labeled results' do
        subject.bind(scope, ['a', 'b']).
          should == 'Expr.parsed([a, b], :labeled => {:word => w})'
      end
    end
  end
end
