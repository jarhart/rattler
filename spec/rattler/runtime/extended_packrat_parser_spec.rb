require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/shared_parser_examples')

describe Rattler::Runtime::ExtendedPackratParser do
  include RuntimeParserSpecHelper
  
  it_behaves_like 'a packrat parser'
  
  describe '#match' do

    it 'supports directly left-recursive rules' do
      given_rules do
        rule :a do
          ( match(:a) & match(/\d/) \
          | match(/\d/)             )
        end
      end.
      parsing('12345a').as(:a).
        should result_in([[[['1', '2'], '3'], '4'], '5']).
        at(5)
    end

    it 'supports indirectly left-recursive rules' do
      given_rules do
        rule(:a) { match(:b) | match(/\d/) }
        rule(:b) { match(:a) & match(/\d/) }
      end.
      parsing('12345a').as(:a).
        should result_in([[[['1', '2'], '3'], '4'], '5']).
        at(5)
    end

  end
  
end
