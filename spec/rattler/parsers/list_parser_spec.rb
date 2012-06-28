require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ListParser do
  include CombinatorParserSpecHelper

  subject { ListParser[term_parser, sep_parser, *bounds] }

  let(:sep_parser) { Match[/[,;]/] }
  let(:bounds) { [0, nil] }

  describe '#parse' do

    context 'with a capturing term parser' do

      let(:term_parser) { Match[/\w+/] }

      context 'with no upper bound' do

        let(:bounds) { [2, nil] }

        context 'when the parser matches enough terms' do
          it 'returns an array with the results of matching the terms' do
            parsing('foo,bar;baz ').should result_in(['foo', 'bar', 'baz']).at(11)
          end
        end

        context 'when the parser matches too few terms' do
          it 'fails' do
            parsing('foo ').should fail
          end
        end

        context 'with a separator not followed by a term' do
          it 'matches without consuming the extra separator' do
            parsing('foo,bar,').should result_in(['foo', 'bar']).at(7)
          end
        end
      end

      context 'with an upper bound' do

        let(:bounds) { [2, 4] }

        context 'when the parser would match too many terms' do
          it 'stops matching at the upper bound' do
            parsing('a,b,c,d,e').should result_in(['a', 'b', 'c', 'd']).at(7)
          end
        end
      end

      context 'with zero-or-more bounds' do

        let(:bounds) { [0, nil] }

        context 'when no terms match' do
          it 'returns an empty array without advancing' do
            parsing('   ').should result_in([]).at(0)
          end
        end

        context 'when a single term matches' do
          it 'returns an array with the result of matching the term' do
            parsing('foo').should result_in(['foo']).at(3)
          end
        end
      end

      context 'with one-or-more bounds' do

        let(:bounds) { [1, nil] }

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
      end
    end

    context 'with a non-capturing term parser' do

      let(:term_parser) { Skip[Match[/\w+/]] }
      let(:bounds) { [2, nil] }

      context 'when the parser matches enough terms' do
        it 'returns true consuming the terms' do
          parsing('foo,bar;baz ').should result_in(true).at(11)
        end
      end

      context 'when the parser matches too few terms' do
        it 'fails' do
          parsing('foo ').should fail
        end
      end

      context 'with zero-or-more bounds' do

        let(:bounds) { [0, nil] }

        context 'when no terms match' do
          it 'returns true without advancing' do
            parsing('   ').should result_in(true).at(0)
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

      context 'with one-or-more bounds' do

        let(:bounds) { [1, nil] }

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
  end

  describe '#capturing?' do

    context 'with a capturing term parser' do

      let(:term_parser) { Match[/\w+/] }

      it 'is true' do
        subject.should be_capturing
      end
    end

    context 'with a non-capturing term parser' do

      let(:term_parser) { Skip[Match[/\w+/]] }

      it 'is false' do
        subject.should_not be_capturing
      end
    end
  end

  describe '#capturing_decidable?' do

    context 'with a decidably capturing parser' do

      let(:term_parser) { Match[/\w+/] }

      it 'is true' do
        subject.should be_capturing_decidable
      end
    end

    context 'with a decidably non-capturing parser' do

      let(:term_parser) { Skip[Match[/\w+/]] }

      it 'is true' do
        subject.should be_capturing_decidable
      end
    end

    context 'with a non-capturing_decidable parser' do

      let(:term_parser) { Apply[:foo] }

      it 'is false' do
        subject.should_not be_capturing_decidable
      end
    end
  end

  describe '#with_ws' do

    let(:ws) { Match[/\s*/] }
    let(:term_parser) { Match[/\w+/] }
    let(:bounds) { [2, 4] }

    it 'applies #with_ws to the term and separator parsers' do
      subject.with_ws(ws).should == ListParser[
        Sequence[Skip[ws], term_parser],
        Sequence[Skip[ws], sep_parser],
        *bounds]
    end
  end

end
