require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Parsers

describe Rattler::BackEnd::ParserGenerator::RuleSetGenerator do

  include ParserGeneratorSpecHelper

  describe '#generate' do
    context 'given rules with no start rule defined' do

      let(:rules) { RuleSet[

        Rule[:a, Choice[
          Match['a'],
          Apply[:b]
        ]],

        Rule[:b, Match['b']]

      ] }

      it 'generates #match_<rule> methods' do
        generated_code {|g| g.generate rules }.
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

# @private
def match_b #:nodoc:
  apply :match_b!
end

# @private
def match_b! #:nodoc:
  @scanner.scan("b")
end
        CODE
      end
    end

    context 'given rules with a start rule defined' do

      let(:rules) { RuleSet[

        Rule[:a, Choice[
          Match['a'],
          Apply[:b]
        ]],

        Rule[:b, Match['b']],

        { :start_rule => :a }
      ] }

      it 'generates #start_rule and #match_<rule> methods' do
        generated_code {|g| g.generate rules }.
        should == (<<-CODE).strip
# @private
def start_rule #:nodoc:
  :a
end

# @private
def match_a #:nodoc:
  apply :match_a!
end

# @private
def match_a! #:nodoc:
  @scanner.scan("a") ||
  match(:b)
end

# @private
def match_b #:nodoc:
  apply :match_b!
end

# @private
def match_b! #:nodoc:
  @scanner.scan("b")
end
        CODE
      end
    end
  end

end