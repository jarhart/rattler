require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/shared_parser_examples')

describe Rattler::Runtime::WDMParser do
  include RuntimeParserSpecHelper
  
  it_behaves_like 'a recursive descent parser'
  
  describe '#match' do
    it 'supports left-recursive rules' do
      given_rules do
        rule :a do
          ( match(:a) & match(:b) \
          | match(:b)             )
        end
        rule :b do
          match /\d/
        end
      end.
      parsing('451a').as(:a).should result_in([['4', '5'], '1']).at(3)
    end
  end
  
end
