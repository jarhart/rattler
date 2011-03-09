require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/shared_parser_examples')

describe Rattler::Runtime::ExtendedPackratParser do
  include RuntimeParserSpecHelper

  it_behaves_like 'a generated packrat parser'

  let :parser_class do
    Rattler::BackEnd::Compiler.compile_parser described_class, grammar
  end

  describe '#match' do

    context 'given a directly left-recursive rule' do
      let(:grammar) { define_grammar do
        rule :a do
          ( match(:a) & match(/\d/) \
          | match(/\d/)             )
        end
      end }

      it 'parses correctly' do
        parsing('12345a').should result_in([[[['1', '2'], '3'], '4'], '5']).at(5)
      end
    end

    context 'given indirectly left-recursive rules' do
      let(:grammar) { define_grammar do
        rule(:a) { match(:b) | match(/\d/) }
        rule(:b) { match(:a) & match(/\d/) }
      end }

      it 'parses correctly' do
        parsing('12345a').should result_in([[[['1', '2'], '3'], '4'], '5']).at(5)
      end
    end
  end

end
