require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/shared_parser_examples')

describe Rattler::Runtime::PackratParser do
  it_behaves_like 'a packrat parser'
end
