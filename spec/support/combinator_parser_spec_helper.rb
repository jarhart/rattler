require 'strscan'

include Rattler::Parsers

module CombinatorParserSpecHelper
  include Rattler::Util::ParserSpecHelper

  @@default_rules = RuleSet[]

  def rules
    @@default_rules
  end

  def scope
    {}
  end

  def parser(&block)
    Rattler::Parsers::ParserBuilder.build(&block)
  end

  def parsing(source)
    CombinatorParsing.new(source, subject, rules, scope)
  end

  class CombinatorParsing
    def initialize(source, parser, rules, scope)
      @scanner = StringScanner.new(source)
      @parser = parser
      @rules = rules
      @scope = scope
    end
    def at(pos)
      @scanner.pos = pos
      self
    end
    def result
      @new_scope = @scope
      @result ||= @parser.parse(@scanner, @rules, @scope) {|_| @new_scope = _ }
    end
    def pos
      @scanner.pos
    end
    def scope
      @new_scope
    end
    def failure
      !result
    end
  end

end
