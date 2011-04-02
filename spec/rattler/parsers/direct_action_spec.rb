require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe DirectAction do
  include CombinatorParserSpecHelper

  subject { DirectAction[nested_parser, code] }

  describe '#parse' do

    context 'with a capturing parser' do

      let(:nested_parser) { Match[/[[:digit:]]+/] }
      let(:code) { '|s| s * 2' }

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

        let(:code) { '_ * 2' }

        it 'applies the action binding the captured result as "_"' do
          parsing('451a').should result_in('451451').at(3)
        end
      end
    end

    context 'with a sequence parser' do

      let :nested_parser do
        Sequence[Match[/[[:alpha:]]+/], Skip[Match[/\=/]], Match[/[[:digit:]]+/]]
      end

      let(:code) { '|l, r| "#{r} -> #{l}"' }

      context 'when the parser matches' do
        it 'applies the action binding the captured results as arguments' do
          parsing('val=42 ').should result_in('42 -> val').at(6)
        end
      end

      context 'using the "_" character' do

        let(:code) { '_.join " <- "' }

        it 'applies the action binding the captured result array as "_"' do
          parsing('val=42 ').should result_in('val <- 42').at(6)
        end
      end
    end

    context 'with an optional parser' do

      let(:nested_parser) { Optional[Match[/\d+/]] }
      let(:code) { '|s| s' }

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

      let(:nested_parser) { ZeroOrMore[Match[/\d/]] }
      let(:code) { '|s| s * 2' }

      context 'when the nested parser matches' do
        it 'applies the action to an array containing the matches' do
          parsing('451a').should result_in(%w{4 5 1 4 5 1}).at(3)
        end
      end

      context 'when the nested parser fails' do
        it 'applies the action to an empty array' do
          parsing('foo').should result_in([]).at(0)
        end
      end
    end

    context 'with a one-or-more parser' do

      let(:nested_parser) { OneOrMore[Match[/\d/]] }
      let(:code) { '|s| s * 2' }

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

    context 'with a list parser' do

      let(:nested_parser) { ListParser[Match[/[[:digit:]]+/], Match[/,/], 2, 4] }
      let(:code) { '_.map {|s| s.to_i }' }

      context 'when the nested parser matches' do
        it 'applies the action to an array containing the matches' do
          parsing('1,2,42').should result_in([1, 2, 42]).at(6)
        end
      end

      context 'when the nested parser fails' do
        it 'fails' do
          parsing('foo').should fail
        end
      end
    end

    context 'with a token parser' do

      let(:nested_parser) { Token[Match[/[[:digit:]]+/]] }
      let(:code) { '|s| s.to_i' }

      context 'when the parser matches' do
        it 'applies the action to the matched string' do
          parsing('42 ').should result_in(42).at(2)
        end
      end
    end

    context 'with a non-capturing parser' do

      let(:nested_parser) { Skip[Match[/\w+/]] }
      let(:code) { '42' }

      context 'when the parser matches' do
        it 'applies the action with no arguments' do
          parsing('abc123 ').should result_in(42).at(6)
        end
      end
    end

    context 'with a labeled parser' do

      let(:nested_parser) { Label[:word, Match[/[[:alpha:]]+/]] }
      let(:code) { 'word * 2' }

      context 'when the parser matches' do
        it 'applies the action binding the label to the result' do
          parsing('foo ').should result_in('foofoo').at(3)
        end
      end
    end

    context 'with a sequence of labeled parsers' do

      let :nested_parser do
        Sequence[
          Label[:left, Match[/[[:alpha:]]+/]],
          Match[/\=/],
          Label[:right, Match[/[[:digit:]]+/]]
        ]
      end

      let(:code) { '"#{right} -> #{left}"' }

      context 'when the parser matches' do
        it 'applies the action binding the labels to the results' do
          parsing('val=42 ').should result_in('42 -> val').at(6)
        end
      end
    end
  end

  describe '#capturing?' do

    let(:code) { '' }

    context 'with a capturing parser' do

      let(:nested_parser) { Match[/\w+/] }

      it 'is true' do
        subject.should be_capturing
      end
    end

    context 'with a non-capturing parser' do

      let(:nested_parser) { Skip[Match[/\s*/]] }

      it 'is false' do
        subject.should_not be_capturing
      end
    end
  end

end
