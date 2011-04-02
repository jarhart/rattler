require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe DispatchAction do
  include CombinatorParserSpecHelper

  subject { DispatchAction[nested_parser] }

  describe '#parse' do

    context 'with a capturing parser' do

      let(:nested_parser) { Match[/[[:digit:]]+/] }

      context 'when the parser matches' do
        it 'applies the action to the result' do
          parsing('451a').
          should result_in(Rattler::Runtime::ParseNode.parsed(['451'])).at(3)
        end
      end

      context 'when the parser fails' do
        it 'fails' do
          parsing('foo').should fail
        end
      end
    end

    context 'with a sequence parser' do

      let(:nested_parser) { Sequence[
        Match[/[[:alpha:]]+/], Match[/\=/], Match[/[[:digit:]]+/]
      ] }

      context 'when the parser matches' do
        it 'applies the action to the result' do
          parsing('val=42').
          should result_in(Rattler::Runtime::ParseNode.parsed(['val','=','42'])).at(6)
        end
      end

      context 'when the parser fails' do
        it 'fails' do
          parsing('val=x').should fail
        end
      end
    end

    context 'with an optional parser' do

      let(:nested_parser) { Optional[Match[/\d+/]] }

      context 'when the nested parser matches' do
        it 'applies the action to an array containing the match' do
          parsing('451a').
          should result_in(Rattler::Runtime::ParseNode.parsed(['451'])).at(3)
        end
      end

      context 'when the nested parser fails' do
        it 'applies the action to an empty array' do
          parsing('foo').
          should result_in(Rattler::Runtime::ParseNode.parsed([])).at(0)
        end
      end
    end

    context 'with a zero-or-more parser' do

      let(:nested_parser) { ZeroOrMore[Match[/\d/]] }

      context 'when the nested parser matches' do
        it 'applies the action to an array containing the matches' do
          parsing('451a').
          should result_in(Rattler::Runtime::ParseNode.parsed(['4', '5', '1'])).at(3)
        end
      end

      context 'when the nested parser fails' do
        it 'applies the action to an empty array' do
          parsing('foo').
          should result_in(Rattler::Runtime::ParseNode.parsed([])).at(0)
        end
      end
    end

    context 'with a one-or-more parser' do

      let(:nested_parser) { OneOrMore[Match[/\d/]] }

      context 'when the nested parser matches' do
        it 'applies the action to an array containing the matches' do
          parsing('451a').
          should result_in(Rattler::Runtime::ParseNode.parsed(['4', '5', '1'])).at(3)
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

      context 'when the nested parser matches' do
        it 'applies the action to an array containing the matches' do
          parsing('1,2,42').
          should result_in(Rattler::Runtime::ParseNode.parsed(['1', '2', '42'])).at(6)
        end
      end

      context 'when the nested parser fails' do
        it 'fails' do
          parsing('foo').should fail
        end
      end
    end

    context 'with a token parser' do

      let(:nested_parser) { Token[Match[/\w+/]] }

      context 'when the parser matches' do
        it 'applies the action to the matched string' do
          parsing('foo ').
          should result_in(Rattler::Runtime::ParseNode.parsed(['foo'])).at(3)
        end
      end
    end

    context 'with a non-capturing parser' do

      let(:nested_parser) { Skip[Match[/,/]] }

      context 'when the parser matches' do
        it 'applies the action to an empty array' do
          parsing(', ').
          should result_in(Rattler::Runtime::ParseNode.parsed([])).at(1)
        end
      end
    end

    context 'with a labeled parser' do

      let(:nested_parser) { Label[:word, Match[/[[:alpha:]]+/]] }

      context 'when the parser matches' do
        it 'applies the action binding the label to the result' do
          parsing('foo ').
          should result_in(Rattler::Runtime::ParseNode.parsed(['foo'],
                                                  :labeled => {:word => 'foo'}))
        end
      end
    end

    context 'with a sequence of labeled parsers' do

      let(:nested_parser) { Sequence[
        Label[:name, Match[/[[:alpha:]]+/]],
        Match[/\=/],
        Label[:value, Match[/[[:digit:]]+/]]
      ] }

      context 'when the parser matches' do
        it 'applies the action binding the labels to the results' do
          parsing('val=42 ').
          should result_in(Rattler::Runtime::ParseNode.parsed(['val','=','42'],
                                  :labeled => {:name => 'val', :value => '42'}))
        end
      end
    end
  end

  describe '#capturing?' do

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
