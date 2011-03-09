require 'strscan'

include Rattler::Parsers

module CombinatorParserSpecHelper
  include Rattler::Util::ParserSpecHelper

  @@default_rules = RuleSet[]

  def rules
    @@default_rules
  end

  def parser(&block)
    Rattler::Parsers::ParserBuilder.build(&block)
  end

  def parsing(source)
    CombinatorParsing.new(source, subject, rules)
  end

  class CombinatorParsing
    def initialize(source, parser, rules)
      @scanner = StringScanner.new(source)
      @parser = parser
      @rules = rules
    end
    def at(pos)
      @scanner.pos = pos
      self
    end
    def labeled(arg={})
      @labeled = arg
      self
    end
    def result
      @result ||= if @labeled
        @parser.parse_labeled(@scanner, @rules, @labeled)
      else
        @parser.parse(@scanner, @rules)
      end
    end
    def pos
      @scanner.pos
    end
    def failure
      !result
    end
  end

end
