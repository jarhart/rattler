require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe DirectAction do
  include CombinatorParserSpecHelper

  describe '#parse' do

    context 'with a capturing parser' do

      subject { DirectAction[Match[/[[:digit:]]+/], '|s| s * 2'] }

      context 'when the parser matches' do
        it 'applies the action binding the captured results as arguments' do
          parsing('451a').should result_in('451451').at(3)
        end
      end

      context 'when the parser fails' do
        it 'fails' do
          parsing('foo').should fail
        end
      end

      context 'using the "_" character' do

        subject { DirectAction[Match[/[[:digit:]]+/], '_ * 2'] }

        it 'applies the action binding the captured result as "_"' do
          parsing('451a').should result_in('451451').at(3)
        end
      end
    end

    context 'with a sequence parser' do
      subject do
        DirectAction[
          Sequence[Match[/[[:alpha:]]+/], Skip[Match[/\=/]], Match[/[[:digit:]]+/]],
          '|l, r| "#{r} -> #{l}"'
        ]
      end

      context 'when the parser matches' do
        it 'applies the action binding the captured results as arguments' do
          parsing('val=42 ').should result_in('42 -> val').at(6)
        end
      end

      context 'using the "_" character' do
        subject do
          DirectAction[
            Sequence[Match[/[[:alpha:]]+/], Skip[Match[/\=/]], Match[/[[:digit:]]+/]],
            '_.join " <- "'
          ]
        end

        it 'applies the action binding the captured result array as "_"' do
          parsing('val=42 ').should result_in('val <- 42').at(6)
        end
      end
    end

    context 'with an optional parser' do

      subject { DirectAction[Optional[Match[/\d+/]], '|s| s'] }

      context 'when the nested parser matches' do
        it 'applies the action to an array containing the match' do
          parsing('451a').should result_in(['451']).at(3)
        end
      end

      context 'when the nested parser fails' do
        it 'applies the action to an empty array' do
          parsing('foo').should result_in([]).at(0)
        end
      end
    end

    context 'with a zero-or-more parser' do

      subject { DirectAction[ZeroOrMore[Match[/\d/]], '|s| s'] }

      context 'when the nested parser matches' do
        it 'applies the action to an array containing the matches' do
          parsing('451a').should result_in(['4', '5', '1']).at(3)
        end
      end

      context 'when the nested parser fails' do
        it 'applies the action to an empty array' do
          parsing('foo').should result_in([]).at(0)
        end
      end
    end

    context 'with a one-or-more parser' do

      subject { DirectAction[OneOrMore[Match[/\d/]], '|s| s * 2'] }

      context 'when the nested parser matches' do
        it 'applies the action to an array containing the matches' do
          parsing('451a').should result_in(%w{4 5 1 4 5 1}).at(3)
        end
      end

      context 'when the nested parser fails' do
        it 'fails' do
          parsing('foo').should fail
        end
      end
    end

    context 'with a token parser' do
      subject { DirectAction[Token[Match[/[[:digit:]]+/]], '|s| s.to_i'] }

      context 'when the parser matches' do
        it 'applies the action to the matched string' do
          parsing('42 ').should result_in(42).at(2)
        end
      end
    end

    context 'with a non-capturing parser' do

      subject { DirectAction[Skip[Match[/\w+/]], '42'] }

      context 'when the parser matches' do
        it 'applies the action with no arguments' do
          parsing('abc123 ').should result_in(42).at(6)
        end
      end
    end

    context 'with a labeled parser' do
      subject do
        DirectAction[
          Label[:word, Match[/[[:alpha:]]+/]],
          "word * 2"
        ]
      end
      context 'when the parser matches' do
        it 'applies the action binding the label to the result' do
          parsing('foo ').should result_in('foofoo').at(3)
        end
      end
    end

    context 'with a sequence of labeled parsers' do
      subject do
        DirectAction[
          Sequence[
            Label[:left, Match[/[[:alpha:]]+/]],
            Match[/\=/],
            Label[:right, Match[/[[:digit:]]+/]]
          ],
          '"#{right} -> #{left}"'
        ]
      end
      context 'when the parser matches' do
        it 'applies the action binding the labels to the results' do
          parsing('val=42 ').should result_in('42 -> val').at(6)
        end
      end
    end
  end

  describe '#capturing?' do

    context 'with a capturing parser' do
      subject { DirectAction[Match[/\w+/], ''] }
      it 'is true' do
        subject.should be_capturing
      end
    end

    context 'with a non-capturing parser' do
      subject { DirectAction[Skip[Match[/\s*/]], ''] }
      it 'is false' do
        subject.should_not be_capturing
      end
    end
  end

end
