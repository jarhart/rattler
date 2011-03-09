require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Parsers

describe Rattler::BackEnd::ParserGenerator::RuleGenerator do

  include ParserGeneratorSpecHelper

  describe '#generate' do

    let(:rule) { Rule[:a, Choice[Match['a'], Apply[:b]]] }

    it 'generates #match_<rule> methods' do
      generated_code {|g| g.generate rule }.
      should == (<<-CODE).strip
# @private
def match_a #:nodoc:
  apply :match_a!
end

# @private
def match_a! #:nodoc:
  @scanner.scan("a") ||
  match(:b)
end
      CODE
    end
  end

end
