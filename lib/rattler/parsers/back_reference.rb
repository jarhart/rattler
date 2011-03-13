#
# = rattler/parsers/back_reference.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +BackReference+ matches the labeled result of an earlier match.
  #
  # @author Jason Arhart
  #
  class BackReference < Parser

    def self.[](ref_label)
      self.new(:ref_label => ref_label.to_sym)
    end

    def self.parsed(results, *_)
      self[results.first[1..-1]]
    end

    def parse(scanner, rules, scope={})
      scanner.scan Regexp.compile(Regexp.escape scope[ref_label])
    end

    def re_expr(scope)
      "/#{re_source scope}/"
    end

    def re_source(scope)
      '#{' + Regexp.escape(scope[ref_label].to_s) + '}'
    end

    # @param (see Parser#with_ws)
    # @return (see Parser#with_ws)
    def with_ws(ws)
      ws.skip & self
    end

  end

end
