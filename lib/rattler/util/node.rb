#
# = rattler/util/node.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/util'

module Rattler::Util
  #
  # A +Node+ is a node that can be used as-is to compose tree structures or
  # as a base class for nodes. It is the base class used for all tree
  # structures in the +Rattler+ framework.
  #
  # @author Jason Arhart
  #
  class Node
    include Enumerable
    
    # Create a +Node+ object.
    #
    # @return [Node]
    #
    # @overload Node.[]()
    #   @return [Node]
    # @overload Node.[](child...)
    #   @return [Node]
    # @overload Node.[](attribute...)
    #   @return [Node]
    # @overload Node.[](child..., attribute...)
    #   @return [Node]
    def self.[](*args)
      self.new(*args)
    end
    
    # Create a +Node+ object.
    #
    # @overload initialize()
    #   @return [Node]
    # @overload initialize(child...)
    #   @return [Node]
    # @overload initialize(attribute...)
    #   @return [Node]
    # @overload initialize(child..., attribute...)
    #   @return [Node]
    def initialize(*args)
      @attrs = args.last.respond_to?(:to_hash) ? args.pop : {}
      @__children__ = args
    end
    
    # Return an array of the node's children
    #
    # @return [Array] the node's children
    def children
      @children ||= if @__children__
        if @__children__.size == 1 && @__children__.first.respond_to?(:to_ary)
          @__children__.first
        else
          @__children__
        end
      else
        []
      end
    end
    
    # Return the node's child at +index+, or the first/only child if no index
    # is given.
    #
    # @param [Integer] index
    # @return the child at +index+, or the first/only child if no index is
    #  given
    def child(index = 0)
      children[index]
    end
    
    # Return a the node's attributes.
    #
    # @return [Hash] the node's attributes
    def attrs
      @attrs ||= {}
    end
    
    # Return the node's name, which is the node's +name+ attribute if it has
    # one, otherwise the name of the node's class.
    #
    # @return the node's name
    def name
      attrs.fetch(:name, self.class.name)
    end
    
    # Call _block_ once for each child, passing that child as an argument.
    #
    # @yield [child]
    def each # :yield: child
      children.each { |_| yield _ }
    end
    
    # Return +true+ if the node has no children.
    #
    # @return [Boolean] +true+ if the node has no children
    def empty?
      children.empty?
    end
    
    # Access the node's children as if the node were an array of its children.
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
    #   @return [Array] the node's children starting at +start+ and
    #     continuing for +length+ children
    # @overload [](range)
    #   Return an array of the node's children specified by +range+.
    #   @param [Range] range the range of children
    #   @return [Array] the node's children specified by +range+
    def [](*args)
      children[*args]
    end
    
    # Return +true+ if the node is equal to +other+. Normally this means
    # +other+ is an instance of the same class or a subclass and has equal
    # children and attributes.
    #
    # @return [Boolean] +true+ if the node is equal to +other+
    def ==(other) #:nodoc:
      self.class === other and
      other.can_equal?(self) and
      self.same_contents?(other)
    end
    
    # Return +true+ if the node has the same value as +other+, i.e. +other+
    # is an instance of the same class and has equal children and attributes.
    #
    # @return [Boolean] +true+ the node has the same value as +other+
    def eql?(other)
      self.class == other.class and
      self.same_contents?(other)
    end
    
    # Allow attributes to be accessed as methods.
    def method_missing(symbol, *args)
      (args.empty? and @attrs.has_key?(symbol)) ? @attrs[symbol] : super
    end
    
    # @private
    def respond_to?(symbol) #:nodoc:
      super || @attrs.has_key?(symbol)
    end
    
    # @private
    def can_equal?(other) #:nodoc:
      self.class == other.class
    end
    
    # @private
    def same_contents?(other) #:nodoc:
      self.children == other.children and
      self.attrs == other.attrs
    end
    
    # @private
    def inspect #:nodoc:
      "#{self.class}[" +
      (children.map {|_| _.inspect } +
        attrs.map {|k, v| k.inspect + '=>' + v.inspect}).join(',') +
      ']'
    end
    
  end
end
