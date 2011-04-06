require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe DispatchAction do
  include CombinatorParserSpecHelper

  subject { DispatchAction[nested] }

  describe '#parse' do

    context 'with a capturing parser' do

      let(:nested) { Match[/[[:digit:]]+/] }

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

      let(:nested) { Sequence[
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

      let(:nested) { Repeat[Match[/\d/], 0, 1] }

      context 'when the nested parser matches' do
        it 'applies the action to an array containing the match' do
          parsing('451a').
          should result_in(Rattler::Runtime::ParseNode.parsed(['4'])).at(1)
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

      let(:nested) { Repeat[Match[/\d/], 0, nil] }

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

      let(:nested) { Repeat[Match[/\d/], 1, nil] }

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

      let(:nested) { ListParser[Match[/[[:digit:]]+/], Match[/,/], 2, 4] }

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

      let(:nested) { Token[Match[/\w+/]] }

      context 'when the parser matches' do
        it 'applies the action to the matched string' do
          parsing('foo ').
          should result_in(Rattler::Runtime::ParseNode.parsed(['foo'])).at(3)
        end
      end
    end

    context 'with a non-capturing parser' do

      let(:nested) { Skip[Match[/,/]] }

      context 'when the parser matches' do
        it 'applies the action to an empty array' do
          parsing(', ').
          should result_in(Rattler::Runtime::ParseNode.parsed([])).at(1)
        end
      end
    end

    context 'with a labeled parser' do

      let(:nested) { Label[:word, Match[/[[:alpha:]]+/]] }

      context 'when the parser matches' do
        it 'applies the action binding the label to the result' do
          parsing('foo ').
          should result_in(Rattler::Runtime::ParseNode.parsed(['foo'],
                                                  :labeled => {:word => 'foo'}))
        end
      end
    end

    context 'with a sequence of labeled parsers' do

      let(:nested) { Sequence[
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

      let(:nested) { Match[/\w+/] }

      it 'is true' do
        subject.should be_capturing
      end
    end

    context 'with a non-capturing parser' do

      let(:nested) { Skip[Match[/\s*/]] }

      it 'is false' do
        subject.should_not be_capturing
      end
    end
  end

  describe '#with_ws' do

    let(:ws) { Match[/\s*/] }
    let(:nested) { Match[/\w+/] }

    it 'applies #with_ws to the nested parser' do
      subject.with_ws(ws).
        should == DispatchAction[Sequence[Skip[ws], nested]]
    end
  end

end
