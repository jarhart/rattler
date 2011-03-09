module RuntimeParserSpecHelper

  include Rattler::Util::ParserSpecHelper

  def define_grammar(*args, &block)
    rules = Rattler::Parsers::ParserDSL.rules(*args, &block)
    Rattler::Grammar::Grammar.new(rules)
  end

end
