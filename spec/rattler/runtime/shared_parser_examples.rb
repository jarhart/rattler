require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

shared_examples_for 'a recursive descent parser' do
  include RuntimeParserSpecHelper
  
  describe '#match' do
    
    it 'dispatches to the correct match method' do
      given_rules { rule(:foo) { match(/\w+/) } }.
      parsing('Hello World!').as(:foo).should result_in('Hello').at(5)
    end
    
    it 'registers parse errors' do
      given_rules { rule(:foo) { match(/d+/) } }.
      parsing('Hello World!').as(:foo).
      should fail.at(0).with_message('foo expected')
    end
    
    it 'supports recursive rules' do
      given_rules do
        rule :a do
          ( match(/\d/) & match(:a) \
          | match(/\d/)             )
        end
      end.
      parsing('451a').as(:a).should result_in(['4', ['5', '1']]).at(3)
    end
    
  end
  
end

shared_examples_for 'a packrat parser' do
  include RuntimeParserSpecHelper

  it_behaves_like 'a recursive descent parser'

  describe '#match' do

    it 'memoizes parse results' do
      example = given_rules do
        rule :a do
          ( match(:b) & match('a') \
          | match(:b) & match('b') )
        end
        rule :b do
          match('b')
        end
      end.
      parsing('bb').as(:a)
      example.parser.should_receive(:match_b).and_return do
        example.parser.pos = example.parser.pos + 1
        'b'
      end
      example.should result_in(['b', 'b']).at(2)
    end

  end

end
