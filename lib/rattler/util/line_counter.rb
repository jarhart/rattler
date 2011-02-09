#
# = rattler/util/line_counter.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/util'

module Rattler::Util
  #
  # A +LineCounter+ takes a linear index into text and calculates line and
  # column numbers.
  #
  # @author Jason Arhart
  #
  class LineCounter
    
    # @private
    @@newline = "\n" #:nodoc:
    
    # @private
    @@tab = "\t" #:nodoc:
    
    # Create a <tt>Rattler::Util::LineCounter</tt> object for +source+.
    #
    # @param [String] source the text in which to count lines
    # @param [Hash] options any optional options for the line counter
    # @option options [Integer] :tab_size (8) the tab size to use for
    #  calculating the column number when tab characters are encountered
    def initialize(source, options={})
      @source = source
      @tab_size = options[:tab_size] || 8
    end
    
    # Return the line number of the character at +index+.
    #
    # @param [Integer] index the (0-based) index into the text
    # @return [Integer] the (1-based) line number at +index+
    def line(index)
      count(index)
      return @line
    end
    
    # Return the column number of the character at +index+. When a _tab_
    # character is encountered the next tab stop is used for the column
    # number of the character following the _tab_ character.
    #
    # @param [Integer] index the (0-based) index into the text
    # @return [Integer] the (1-based) column number at +index+
    def column(index)
      count(index)
      return @column
    end
    
    private
    
    def count(index)
      unless @index == index
        @index = index
        @line = 1
        i = p = 0
        while (i = @source.index(@@newline, p)) and (i < index)
          @line += 1
          p = i + 1
        end
        @column = 1
        for i in p...index
          @column = @source[i,1] == @@tab ? next_tab_stop : @column + 1
        end
      end
    end
    
    def next_tab_stop
      ((@column - 1) / @tab_size + 1) * @tab_size + 1
    end
    
  end
end
