#
# = rattler/parsers/fail.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  #
  # +Fail+ is a parser that always fails. It can be used to define more useful
  # error messages.
  #
  # @author Jason Arhart
  #
  class Fail < Parser

    # @private
    def self.parsed(results, *_) #:nodoc:
      keyword, arg_expr = results
      arg = eval(arg_expr)
      case keyword
      when 'fail'       then self[:expr, arg]
      when 'fail_rule'  then self[:rule, arg]
      when 'fail_parse' then self[:parse, arg]
      when 'expected'   then self[:expr, arg.to_sym]
      end
    end

    # Create a new parser that always fails with +message+. The +type+ should
    # be one of <tt>:expr</tt>, <tt>:rule</tt> or <tt>:parse</tt>, indicating
    # to simply fail, to cause its parse rule to fail, or to cause the entire
    # parse to fail, respectively.
    #
    # @param [Symbol] type <tt>:expr</tt>, <tt>:rule</tt> or <tt>:parse</tt>
    #
    # @return [Fail] a new parser that always fails with +message+
    def self.[](type, message)
      self.new(:type => type, :message => message)
    end

    # Always return +false+. The parser code generated for this parser should
    # use +message+ as the failure message, and should cause its parse rule
    # to fail if +type+ is <tt>:rule</tt> or cause the entire parse to fail
    # +type+ is <tt>:parse</tt>
    #
    # @param (see Parser#parse_labeled)
    #
    # @return false
    def parse(*_)
      false
    end

    # Always +false+
    # @return false
    def capturing?
      false
    end

  end
end
