require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rattler::Parsers::NodeCode do

  subject { described_class.new(target_name, method_name, target_attrs) }

  let(:target_name) { 'Expr' }
  let(:method_name) { 'parsed' }
  let(:target_attrs) { {} }

  describe '#bind' do

    let(:scope) { ParserScope.new(bindings) }

    let(:bindings) { {} }

    context 'given a bind arg' do
      it 'binds the exact string' do
        subject.bind(scope, 'a').should == 'Expr.parsed(a)'
      end
    end

    context 'with scope' do

      let(:bindings) { {:word => 'w'} }

      it 'binds the scope as labeled results' do
        subject.bind(scope, 'a').
          should == 'Expr.parsed(a, :labeled => {:word => w})'
      end
    end

    context 'with target_attrs' do

      let(:target_attrs) { {:name => 'expression'} }

      it '' do
        subject.bind(scope, 'a').
          should == 'Expr.parsed(a, :name => "expression")'
      end
    end
  end
end
