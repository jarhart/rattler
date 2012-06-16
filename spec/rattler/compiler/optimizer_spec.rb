require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/shared_compiler_examples')

describe Rattler::Compiler::Optimizer do
  include CompilerSpecHelper

  describe '.optimize result' do

    let :compiled_parser do
      combinator_parser described_class.optimize(grammar)
    end

    it_behaves_like 'a compiled parser'

  end
end
