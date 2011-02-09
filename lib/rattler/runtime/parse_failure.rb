#
# = rattler/runtime/parse_error.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/runtime'

module Rattler::Runtime
  #
  # A +ParseFailure+ represents a position and explanation of a failed parse.
  #
  # @author Jason Arhart
  #
  class ParseFailure
    
    # Create a new parse error object.
    #
    # @overload initialize(source, pos)
    #   Create a new parse error object with no message.
    #   @param [String] source the source code being parsed
    #   @param [Integer] pos the position of the error in the source code
    #
    # @overload initialize(source, pos, message)
    #   Create a new parse error object using +message+ as the message.
    #   @param [String] source the source code being parsed
    #   @param [Integer] pos the position of the error in the source code
    #   @param [String] message a message explaining the error
    #
    # @overload initialize(source, pos, rule_name)
    #   Create a new parse error object using <tt>"#{rule_name} expected"</tt>
    #   as the message.
    #   @param [String] source the source code being parsed
    #   @param [Integer] pos the position of the error in the source code
    #   @param [Symbol] rule_name the name of the rule that failed
    #
    def initialize(source, pos, message_or_rule_name=nil)
      @source = source
      @pos = pos
      if message_or_rule_name
        @message ||= case message_or_rule_name
        when Symbol then "#{message_or_rule_name} expected"
        else message_or_rule_name
        end
      end
      @lc = Rattler::Util::LineCounter.new(source)
    end
    
    attr_reader :pos, :message
    
    # Return the (1-based) column number where the parse error occurred.
    # @return [Integer] the column number where the parse error occurred.
    def column
      @lc.column(pos)
    end
    
    # Return the (1-based) line number where the parse error occurred.
    # @return [Integer] the line number where the parse error occurred.
    def line
      @lc.line(pos)
    end
    
    # Return a string representation of the parse error suitable for showing
    # to the user, e.g. "parse error at line 17, column 42: expr expected"
    #
    # @return [String] a string representation of the parse error suitable for showing
    #   to the user
    def to_s
      message ? "#{intro_str}:\n #{message}" : intro_str
    end
    
    private
    
    def intro_str
      "parse error #{pos_str}"
    end
    
    def pos_str
      "at line #{line}, column #{column}"
    end
    
  end
end
