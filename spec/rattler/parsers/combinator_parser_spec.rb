require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../runtime/shared_parser_examples')

describe Rattler::Parsers::CombinatorParser do
  include Rattler::Util::ParserSpecHelper
  include RuntimeParserSpecHelper

  it_behaves_like 'a recursive descent parser'

  let :parser_class do
    Rattler::Parsers::CombinatorParser.as_class(grammar.start_rule, grammar.rules)
  end

end
