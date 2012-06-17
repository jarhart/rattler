require 'rattler/parsers'

module Rattler::Parsers

  # +BackReference+ matches the labeled result of an earlier match.
  class BackReference < Parser

    # @param [Symbol,String] ref_label the label referencing the earlier match
    # @return [BackReference] a new parser that matches the value an earlier
    #   match whose result is labeled by +ref_label+
    def self.[](ref_label)
      self.new(:ref_label => ref_label.to_sym)
    end

    # @private
    def self.parsed(results, *_)
      self[results.first[1..-1]]
    end

    # If the earlier referenced match result appears again at the parse
    # position, match that string, otherwise return a false value.
    #
    # @param (see Match#parse)
    #
    # @return the matched string, or +nil+
    def parse(scanner, rules, scope = ParserScope.empty)
      scanner.scan Regexp.compile(Regexp.escape scope[ref_label])
    end

    # @param [ParserScope] scope the scope of captured results
    # return [String] ruby code for a +Regexp+ that matches the earlier
    #   referenced match result
    def re_expr(scope)
      "/#{re_source scope}/"
    end

    # @param [ParserScope] scope the scope of captured results
    # return [String] the source of a +Regexp+ that matches the earlier
    #   referenced match result
    def re_source(scope)
      '#{' + Regexp.escape(scope[ref_label].to_s) + '}'
    end

    # (see Parser#with_ws)
    def with_ws(ws)
      ws.skip & self
    end

  end

end
