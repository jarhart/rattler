require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe List1 do
  include CombinatorParserSpecHelper

  describe '#parse' do

    context 'with a capturing term parser' do

      subject { List1[Match[/\w+/], Match[/[,;]/]] }

      context 'when no terms match' do
        it 'fails' do
          parsing('   ').should fail
        end
      end

      context 'when a single term matches' do
        it 'returns an array with the result of matching the term' do
          parsing('foo').should result_in(['foo']).at(3)
        end
      end

      context 'when multiple terms match' do
        it 'returns an array with the results of matching the terms' do
          parsing('foo,bar;baz ').should result_in(['foo', 'bar', 'baz']).at(11)
        end
      end

      context 'with a separator not followed by a term' do
        it 'matches without consuming the extra separator' do
          parsing('foo,bar,').should result_in(['foo', 'bar']).at(7)
        end
      end
    end

    context 'with a non-capturing parser' do

      subject { List1[Skip[Match[/\w+/]], Match[/[,;]/]] }

      context 'when no terms match' do
        it 'fails' do
          parsing('   ').should fail
        end
      end

      context 'when a single term matches' do
        it 'returns true consuming the term' do
          parsing('foo  ').should result_in(true).at(3)
        end
      end

      context 'when multiple terms match' do
        it 'returns true consuming the list' do
          parsing('foo,bar;baz  ').should result_in(true).at(11)
        end
      end
    end
  end

  describe '#capturing?' do

    context 'with a capturing term parser' do

      subject { List1[Match[/\w+/], Match[/[,;]/]] }

      it 'is true' do
        subject.should be_capturing
      end
    end

    context 'with a non-capturing term parser' do

      subject { List1[Skip[Match[/\w+/]], Match[/[,;]/]] }

      it 'is true' do
        subject.should_not be_capturing
      end
    end
  end

end
