require 'rattler'

describe 'Rattler' do

  describe '.define_rules' do

    context 'given a parser DSL block' do

      let(:result) { Rattler.define_rules do
        rule(:word) { match /\w+/ }
        rule(:num) { match /\d+/ }
      end }

      it 'returns a set of parse rules defined by the block' do
        result.should == Rattler::Parsers::RuleSet[
          Rattler::Parsers::Rule[:word, Rattler::Parsers::Match[/\w+/]],
          Rattler::Parsers::Rule[:num, Rattler::Parsers::Match[/\d+/]]
        ]
      end
    end
  end

  describe '.compile_parser' do

    context 'given a parser DSL block' do

      let(:result) { Rattler.compile_parser do
        rule(:word) { match /\w+/ }
        rule(:num) { match /\d+/ }
      end }

      it 'returns a parser class with rule methods defined by the block' do
        result.should have_method(:match_word)
        result.should have_method(:match_num)
      end
    end

    context 'given a grammar source string' do

      let(:result) { Rattler.compile_parser({}, %{
        word  <-  /\w+/
        num   <-  /\d+/
      })}

      it 'returns a parser class with rule methods defined by the grammar' do
        result.should have_method(:match_word)
        result.should have_method(:match_num)
      end
    end
  end

  def have_method(rule_name)
    be_method_defined(rule_name)
  end

end
