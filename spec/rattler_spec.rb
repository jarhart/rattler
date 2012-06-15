require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'rattler'

describe 'Rattler' do

  describe '.compile_parser' do

    let(:result) { Rattler.compile_parser(%{
      word  <-  @WORD+
      num   <-  @DIGIT+
    })}

    it 'returns a parser class with rule methods defined by the grammar' do
      result.should have_method(:match_word)
      result.should have_method(:match_num)
    end
  end

  def have_method(rule_name)
    be_method_defined(rule_name)
  end

end
