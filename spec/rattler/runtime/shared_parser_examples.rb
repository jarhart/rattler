require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

shared_examples_for 'a recursive descent parser' do
  include RuntimeParserSpecHelper

  describe '#parse' do

    let(:grammar) { define_grammar do
      rule(:word) { match(/\w+/) }
    end }

    it 'applies the start rule to the source' do
      parsing('Hello World!').should result_in('Hello').at(5)
    end

  end
end

shared_examples_for 'a generated recursive descent parser' do
  include RuntimeParserSpecHelper

  it_behaves_like 'a recursive descent parser'

  let(:parser_class) do
    Rattler::BackEnd::Compiler.compile_parser described_class, grammar
  end

  describe '#match' do

    let(:grammar) { define_grammar do
      rule(:word) { match(/\w+/) }
    end }

    it 'dispatches to the correct match method' do
      matching('Hello World!').as(:word).should result_in('Hello').at(5)
    end

    it 'registers parse errors' do
      matching('@').as(:word).
      should fail.at(0).with_message('word expected')
    end

    context 'given recursive rules' do

      let(:grammar) { define_grammar do
        rule :a do
          ( match(/\d/) & match(:a) \
          | match(/\d/)             )
        end
      end }

      it 'applies the rules recursively' do
        matching('1234abc').as(:a).should result_in(['1', ['2', ['3', '4']]]).at(4)
      end
    end
  end

end

shared_examples_for 'a generated packrat parser' do
  include RuntimeParserSpecHelper

  it_behaves_like 'a generated recursive descent parser'

  let(:parser_class) do
    Rattler::BackEnd::Compiler.compile_parser described_class, grammar
  end

  describe '#match' do

    context 'given recursive rules' do

      let(:grammar) { define_grammar do
        rule :a do
          ( match(:b) & match('a') \
          | match(:b) & eof )
        end
        rule :b do
          match('b') & disallow(:a)
        end
      end }

      let(:example) { matching('bag').as(:a) }

      it 'memoizes parse results' do
        example.parser.should_receive(:match_b!).
          and_return { example.parser.pos += 1; 'b' }
        example.should result_in(['b', 'a']).at(2)
      end
    end
  end

end
