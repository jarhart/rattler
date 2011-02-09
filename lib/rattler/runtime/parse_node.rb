#
# = rattler/runtime/parse_node.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/runtime'

module Rattler::Runtime
  #
  # +ParseNode+ is intended as s a convenient class to use as a parsing
  # result type.
  #
  # @author Jason Arhart
  #
  class ParseNode < Rattler::Util::Node
    
    # Create a parse node from the results of a parsing expression.
    #
    # @param [Array] children the children of the parse node
    # @param [Hash] attrs any attributes for the parse node
    #
    # @return [ParseNode] a new parse node
    #
    def self.parsed(children, attrs={})
      self.new(children, attrs.reject {|_, val| val.nil? })
    end
    
    # Access the parse node's children.
    #
    # @overload [](index)
    #   Return the node's child at +index+.
    #   @param [Integer] index index of the child
    #   @return the child at +index+
    # @overload [](start, length)
    #   Return an array of the node's children starting at +start+ and
    #   continuing for +length+ children.
    #   @param [Integer] start the index of the first child
    #   @param [Integer] length the number of children to return
    #   @return [Array] the node's children starting at +start+ and continuing
    #     for +length+ children
    # @overload [](range)
    #   Return an array of the node's children specified by +range+.
    #   @param [Range] range the range of children
    #   @return [Array] the node's children specified by +range+
    # @overload [](label)
    #   Return the labeled child associated with +label+.
    #   @param [Symbol] a label
    #   @return the labeled child associated with +label+
    def [](*args)
      if args.size == 1 and args.first.is_a?(Symbol)
        labeled[args[0]]
      else
        super
      end
    end
    
    # Return a hash associating labels with the labeled children
    # @return [Hash] a hash associating labels with the labeled children
    def labeled
      attrs.fetch(:labeled, {})
    end
    
    # Return +true+ if the node has the same value as +other+, i.e. +other+
    # is an instance of the same class and has equal children and attributes
    # and the children are labeled the same.
    #
    # @return [Boolean] +true+ the node has the same value as +other+
    def eql?(other) #:nodoc
      super &&
      self.labeled == other.labeled
    end
    
    # Allow labeled children to be accessed as methods.
    def method_missing(symbol, *args)
      (args.empty? and labeled.has_key?(symbol)) ? labeled[symbol] : super
    end
    
    # @private
    def respond_to?(symbol) #:nodoc:
      super || labeled.has_key?(symbol)
    end
    
  end
end
