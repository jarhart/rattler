require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Compiler::ParserGenerator

describe GroupMatch do
  include CombinatorParserSpecHelper

  let(:single_group) { GroupMatch[Match[/\s*(\w+)/], {:num_groups => 1}] }
  let(:multi_group) { GroupMatch[Match[/\s*(\w+)\s+(\w+)/], {:num_groups => 2}] }

  describe '#parse' do

    context 'with a single group' do

      subject { single_group }

      context 'when the regexp matches' do
        it 'succeeds returning the matched group' do
          parsing('  abc123  ').should result_in('abc123').at(8)
        end
      end

      context 'when the regexp does not match' do
        it 'fails' do
          parsing('==').should fail
        end
      end
    end

    context 'with multiple groups' do

      subject { multi_group }

      context 'when the regexp matches' do
        it 'succeeds returning the matched groups in an array' do
          parsing(' abc 123 ').should result_in(['abc', '123']).at(8)
        end
      end
    end
  end

  describe '#capturing?' do

    subject { single_group }

    it 'is true' do
      subject.should be_capturing
    end
  end

end
