require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rattler::Parsers::ActionCode do

  subject { ActionCode.new(code) }

  describe '#param_names' do
    context 'when the code has block parameters' do

      subject { ActionCode.new('|a, b| a + b') }

      it 'returns an array of the parameter names' do
        subject.param_names.should == ['a', 'b']
      end
    end

    context 'when the code has no block paratmers' do

      subject { ActionCode.new('l + r') }

      it 'returns an empty array' do
        subject.param_names.should == []
      end
    end
  end

  describe '#body' do
    context 'when the code has block parameters' do

      subject { ActionCode.new('|a, b| a + b') }

      it 'returns the code after the block parameters' do
        subject.body.should == 'a + b'
      end
    end

    context 'when the code has no block paratmers' do

      subject { ActionCode.new('l + r') }

      it 'returns the code' do
        subject.body.should == 'l + r'
      end
    end
  end

  describe '#arg_bindings' do
    context 'when the code has block parameters' do

      subject { ActionCode.new('|a, b| a + b') }

      it 'associates the parameter names with arguments' do
        subject.arg_bindings(['r0_0', 'r0_1']).
          should == {/\ba\b/ => 'r0_0', /\bb\b/ => 'r0_1'}
      end

      it 'allows more args than param names' do
        subject.arg_bindings(['r0_0', 'r0_1', 'r0_2']).
          should == {/\ba\b/ => 'r0_0', /\bb\b/ => 'r0_1'}
      end
    end

    context 'when the code has no block paratmers' do

      subject { ActionCode.new('l + r') }

      it 'returns an empty hash' do
        subject.arg_bindings(['r0_0', 'r0_1']).should == {}
      end
    end
  end

  describe '#bind' do

    let(:scope) { {} }

    context 'when the code uses block parameters' do

      let(:code) { '|a, b| a + b' }

      it 'replaces block parameter names with corresponding arguments' do
        subject.bind(scope, ['r0_0', 'r0_1']).should == 'r0_0 + r0_1'
      end
    end

    context 'when the code refers to labels' do

      let(:scope) { {:l => 'r0_3', :r => 'r0_5'} }

      let(:code) { 'l + r' }

      it 'replaces label names with associated arguments' do
        subject.bind(scope, []).should == 'r0_3 + r0_5'
      end
    end

    context 'when the code uses block parameters and label names' do

      let(:scope) { {:c => 'r0_3', :d => 'r0_5'} }

      let(:code) { '|a, b| a * c + b * d' }

      it 'replaces both block parameter names and label names' do
        subject.bind(scope, ['r0_0', 'r0_1']).
          should == 'r0_0 * r0_3 + r0_1 * r0_5'
      end
    end

    context 'when the code uses block parameters that are label names' do

      let(:scope) { {:b => 'r0_3', :c => 'r0_5'} }

      let(:code) { '|a, b| a * c + b' }

      it 'the block parameters shadow the label names' do
        subject.bind(scope, ['r0_0', 'r0_1']).
          should == 'r0_0 * r0_5 + r0_1'
      end
    end

    context 'when the code uses "_"' do

      let(:code) { '_.to_s' }

      context 'given one argument' do
        it 'replaces "_" with the argument' do
          subject.bind(scope, ['r0']).should == 'r0.to_s'
        end
      end

      context 'given multiple arguments' do
        it 'replaces "_" with the array of arguments' do
          subject.bind(scope, ['r0_0', 'r0_1']).
            should == '[r0_0, r0_1].to_s'
        end
      end
    end

    context 'when the code uses "_" as a block parameter' do

      let(:code) { '|_| _.to_f' }

      it 'the block parameter shadows the default "_" binding' do
        subject.bind(scope, ['r0_0', 'r0_1']).should == 'r0_0.to_f'
      end
    end

    context 'when the code uses "*_"' do

      let(:code) { 'do_stuff *_' }

      context 'given one argument' do
        it 'replaces "*_" with the argument' do
          subject.bind(scope, ['r0']).should == 'do_stuff r0'
        end
      end

      context 'given multiple arguments' do
        it 'replaces "*_" with the arguments' do
          subject.bind(scope, ['r0_0', 'r0_1']).
            should == 'do_stuff r0_0, r0_1'
        end
      end
    end
  end

end
