require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/general_list_generator_examples')
require File.expand_path(File.dirname(__FILE__) + '/list0_generator_examples')
require File.expand_path(File.dirname(__FILE__) + '/list1_generator_examples')

include Rattler::Parsers

describe Rattler::BackEnd::ParserGenerator::ListGenerator do

  include ParserGeneratorSpecHelper

  let(:list) { ListParser[term_parser, sep_parser, *bounds] }

  it_behaves_like 'a general list generator'
  it_behaves_like 'a list0 generator'
  it_behaves_like 'a list1 generator'

end
