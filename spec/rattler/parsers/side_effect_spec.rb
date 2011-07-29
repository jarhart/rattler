require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe SideEffect do
  include CombinatorParserSpecHelper

  subject { SideEffect[nested, code] }

  before { $__side_effect_result__ = nil }

  describe '#parse' do

    context 'with a capturing parser' do

      let(:nested) { Match[/[[:digit:]]+/] }
      let(:code) { '|s| $__side_effect_result__ = s * 2' }

      context 'when the parser matches' do
        it 'applies the action binding the captured results as arguments' do
          parsing('451a').should result_in('451').at(3)
          $__side_effect_result__.should == '451451'
        end
      end

      context 'when the parser fails' do
        it 'fails' do
          parsing('foo').should fail
        end
      end

      context 'using the "_" character' do

        let(:code) { '$__side_effect_result__ = _ * 2' }

        it 'applies the action binding the captured result as "_"' do
          parsing('321a').should result_in('321').at(3)
          $__side_effect_result__.should == '321321'
        end
      end
    end

    context 'with a sequence parser' do

      let :nested do
        Sequence[Match[/[[:alpha:]]+/], Skip[Match[/\=/]], Match[/[[:digit:]]+/]]
      end

      let(:code) { '|l, r| $__side_effect_result__ = "#{r} -> #{l}"' }

      context 'when the parser matches' do
        it 'applies the action binding the captured results as arguments' do
          parsing('val=42 ').should result_in(['val', '42']).at(6)
          $__side_effect_result__.should == '42 -> val'
        end
      end

      context 'using the "_" character' do

        let(:code) { '$__side_effect_result__ = _.join " <- "' }

        it 'applies the action binding the captured result array as "_"' do
          parsing('val=42 ').should result_in(['val', '42']).at(6)
          $__side_effect_result__.should == 'val <- 42'
        end
      end
    end

    context 'with an optional parser' do

      let(:nested) { Repeat[Match[/\d/], 0, 1] }
      let(:code) { '|s| $__side_effect_result__ = s' }

      context 'when the nested parser matches' do
        it 'applies the action to an array containing the match' do
          parsing('451a').should result_in(['4']).at(1)
          $__side_effect_result__.should == ['4']
        end
      end
    end

    context 'with a zero-or-more parser' do

      let(:nested) { Repeat[Match[/\d/], 0, nil] }
      let(:code) { '|s| $__side_effect_result__ = s * 2' }

      context 'when the nested parser matches' do
        it 'applies the action to an array containing the matches' do
          parsing('451a').should result_in(%w{4 5 1}).at(3)
          $__side_effect_result__.should == %w{4 5 1 4 5 1}
        end
      end
    end

    context 'with a one-or-more parser' do

      let(:nested) { Repeat[Match[/\d/], 1, nil] }
      let(:code) { '|s| $__side_effect_result__ = s * 2' }

      context 'when the nested parser matches' do
        it 'applies the action to an array containing the matches' do
          parsing('451a').should result_in(%w{4 5 1}).at(3)
          $__side_effect_result__.should == %w{4 5 1 4 5 1}
        end
      end
    end

    context 'with a list parser' do

      let(:nested) { ListParser[Match[/[[:digit:]]+/], Match[/,/], 2, 4] }
      let(:code) { '$__side_effect_result__ = _.map {|s| s.to_i }' }

      context 'when the nested parser matches' do
        it 'applies the action to an array containing the matches' do
          parsing('1,2,42').should result_in(["1", "2", "42"]).at(6)
          $__side_effect_result__.should == [1, 2, 42]
        end
      end
    end

    context 'with a token parser' do

      let(:nested) { Token[Match[/[[:digit:]]+/]] }
      let(:code) { '|s| $__side_effect_result__ = s.to_i' }

      context 'when the parser matches' do
        it 'applies the action to the matched string' do
          parsing('42 ').should result_in('42').at(2)
          $__side_effect_result__.should == 42
        end
      end
    end

    context 'with a non-capturing parser' do

      let(:nested) { Skip[Match[/\w+/]] }
      let(:code) { '$__side_effect_result__ = 42' }

      context 'when the parser matches' do
        it 'applies the action with no arguments' do
          parsing('abc123 ').should result_in(true).at(6)
          $__side_effect_result__.should == 42
        end
      end
    end

    context 'with a labeled parser' do

      let(:nested) { Label[:word, Match[/[[:alpha:]]+/]] }
      let(:code) { '$__side_effect_result__ = word * 2' }

      context 'when the parser matches' do
        it 'applies the action binding the label to the result' do
          parsing('foo ').should result_in('foo').at(3)
          $__side_effect_result__.should == 'foofoo'
        end
      end
    end

    context 'with a sequence of labeled parsers' do

      let :nested do
        Sequence[
          Label[:left, Match[/[[:alpha:]]+/]],
          Match[/\=/],
          Label[:right, Match[/[[:digit:]]+/]]
        ]
      end

      let(:code) { '$__side_effect_result__ = "#{right} -> #{left}"' }

      context 'when the parser matches' do
        it 'applies the action binding the labels to the results' do
          parsing('val=42 ').should result_in(['val', '=', '42']).at(6)
          $__side_effect_result__.should == '42 -> val'
        end
      end
    end
  end

  describe '#capturing?' do

    let(:code) { '' }

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
    let(:code) { '' }

    it 'applies #with_ws to the nested parser' do
      subject.with_ws(ws).
        should == SideEffect[Sequence[Skip[ws], nested], code]
    end
  end

end
