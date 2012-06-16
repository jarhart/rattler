require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Compiler::ParserGenerator
include Rattler::Parsers

describe NodeActionGenerator do

  include ParserGeneratorSpecHelper
  include Rattler::Runtime

  let(:action) { NodeAction['Expr'] }

  let(:scope) { ParserScope.new(bindings, captures) }
  let(:bindings) { {} }
  let(:captures) { [] }

  describe '#gen_basic' do

    context 'with no bindings or captures' do
      it 'generates node action code' do
        top_level_code {|g| g.gen_basic action, scope }.
        should == 'Expr.parsed([])'
      end
    end

    context 'with a single capture' do

      let(:captures) { ['r0_0'] }

      it 'generates node action code with the capture in an array' do
        top_level_code {|g| g.gen_basic action, scope }.
        should == 'Expr.parsed([r0_0])'
      end
    end

    context 'with multiple captures' do

      let(:captures) { ['r0_0', 'r0_1'] }

      it 'generates node action code with the capture in an array' do
        top_level_code {|g| g.gen_basic action, scope }.
        should == 'Expr.parsed([r0_0, r0_1])'
      end
    end

    context 'with bindings' do

      let(:bindings) { {:a => 'r0_1'} }

      it 'generates node action code with the bindings as a :labeled attribute' do
        top_level_code {|g| g.gen_basic action, scope }.
        should == 'Expr.parsed([], :labeled => {:a => r0_1})'
      end
    end

    context 'with undecidable captures' do

      let(:captures) { ['r0_0', 'r0_1'] }

      it 'generates node action code that uses select_captures' do
        top_level_code {|g| g.gen_basic action, scope.with_undecidable_captures }.
        should == 'Expr.parsed(select_captures([r0_0, r0_1]))'
      end
    end

    context 'when the action has an alternate factory method' do

      let(:action) { NodeAction['Expr', {:method => 'create'}] }

      it 'generates node action code with the factory method' do
        top_level_code {|g| g.gen_basic action, scope }.
        should == 'Expr.create([])'
      end
    end

    context 'when the action has node attributes' do

      let(:action) { NodeAction['Expr', {:node_attrs => {:name => "FOO"}}] }

      it 'generates node action code with the node attributes' do
        top_level_code {|g| g.gen_basic action, scope }.
        should == 'Expr.parsed([], :name => "FOO")'
      end
    end
  end

  describe '#gen_assert' do

    context 'when nested' do
      it 'generates nested node assert code' do
        nested_code {|g| g.gen_assert action }.
        should == '(Expr.parsed([]) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level node assert code' do
        top_level_code {|g| g.gen_assert action }.
        should == 'Expr.parsed([]) && true'
      end
    end
  end

  describe '#gen_disallow' do
    it 'generates node disallow code' do
      top_level_code {|g| g.gen_disallow action }.
      should == '!Expr.parsed([])'
    end
  end

  describe '#gen_token' do
    it 'generates node token code' do
      top_level_code {|g| g.gen_token action }.
      should == 'Expr.parsed([]).to_s'
    end
  end

  describe '#gen_skip' do

    context 'when nested' do
      it 'generates nested node skipping code' do
        nested_code {|g| g.gen_skip action }.
        should == '(Expr.parsed([]); true)'
      end
    end

    context 'when top-level' do
      it 'generates top level node skipping code' do
        top_level_code {|g| g.gen_skip action }.
        should == 'Expr.parsed([]); true'
      end
    end
  end

end
