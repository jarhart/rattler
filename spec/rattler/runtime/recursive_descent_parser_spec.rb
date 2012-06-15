require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/shared_parser_examples')

describe Rattler::Runtime::RecursiveDescentParser do

  it_behaves_like 'a generated recursive descent parser'

  describe '.grammar' do

    let(:parser_class) { Class.new(described_class) }

    context 'given a string' do

      before { parser_class.module_eval do
        grammar <<-G
          word  <-  @WORD+
          num   <-  @DIGIT+
        G
      end }

      it 'defines rule methods using the grammar syntax' do
        parser_class.should have_method(:match_word)
        parser_class.should have_method(:match_num )
      end
    end
  end

  def have_method(rule_name)
    be_method_defined(rule_name)
  end

end
