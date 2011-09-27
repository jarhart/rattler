require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rattler::Grammar::GrammarDSL do

  let :parser_class do
    c = Class.new
    c.module_eval { include Rattler::Grammar::GrammarDSL }
    c
  end

  describe '.start_rule' do

    before { parser_class.module_eval { start_rule :a } }

    it 'defines a start_rule method' do
      parser_class.new.start_rule.should == :a
    end
  end

  describe '.rules' do

    before { parser_class.module_eval do
      rules do
        rule(:word) { match /\w+/ }
        rule(:num) { match /\d+/ }
      end
    end }

    it 'defines rule methods using the internal DSL' do
      parser_class.should have_method(:match_word)
      parser_class.should have_method(:match_num )
    end
  end

  describe '.grammar' do

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

    context 'given a block' do

      before { parser_class.module_eval do
        grammar do
          rule(:word) { match /\w+/ }
          rule(:num) { match /\d+/ }
        end
      end }

      it 'defines rule methods using the internal DSL' do
        parser_class.should have_method(:match_word)
        parser_class.should have_method(:match_num )
      end
    end
  end

  describe '.rule' do

    before { parser_class.module_eval do
      rule(:word) { match /\w+/ }
    end }

    it 'defines a rule method using the internal DSL' do
      parser_class.should have_method(:match_word)
    end
  end

  def have_method(rule_name)
    be_method_defined(rule_name)
  end

end
