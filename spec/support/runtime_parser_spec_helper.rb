module RuntimeParserSpecHelper
  
  include Rattler::Util::ParserSpecHelper
  
  def given_rules(&block)
    GivenRules.new(Rattler.compile_parser({:class => described_class}, &block))
  end
  
  class GivenRules
    def initialize(parser_class)
      @parser_class = parser_class
    end
    def parsing(source)
      Rattler::Util::ParserSpecHelper::Parsing.new(@parser_class.new(source))
    end
  end
  
end
