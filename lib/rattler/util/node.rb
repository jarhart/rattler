require 'rattler/util'

module Rattler::Util

  # A +Node+ is a node that can be used as-is to compose tree structures or
  # as a base class for user-defined node types. It is the base class used for
  # all tree structures in the +Rattler+ framework.
  class Node
    include Enumerable

    # @overload Node.[]()
    #   @return [Node] a +Node+ object with no children or attributes
    # @overload Node.[](child...)
    #   @return [Node] a +Node+ object with children and no attributes
    # @overload Node.[](attribute...)
    #   @return [Node] a +Node+ object with attributes and no children
    # @overload Node.[](child..., attribute...)
    #   @return [Node] a +Node+ object with children and attributes
    def self.[](*args)
      self.new(*args)
    end

    # @overload initialize()
    #   Create a +Node+ object with no children or attributes.
    # @overload initialize(child...)
    #   Create a +Node+ object with children and no attributes.
    # @overload initialize(attribute...)
    #   Create a +Node+ object with attributes and no children.
    # @overload initialize(child..., attribute...)
    #   Create a +Node+ object with children and attributes.
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
      block_given? ? children.each { |_| yield _ } : children.each
    end

    # @param [Array] new_children a new array of children
    # @return [Node] a new code with the new children replacing the node's
    #   children
    def with_children(new_children)
      self.class.new(new_children, attrs)
    end

    alias_method :with_child, :with_children

    # @param (see #new_attrs!)
    # @return [Node] a new node with the new attributes added to the node's
    #   attributes
    def with_attrs(new_attrs)
      self.with_attrs!(attrs.merge new_attrs)
    end

    # @param [Hash] new_attrs a new set of attributes
    # @return [Node] a new node with the new attributes replacing the node's
    #   attributes
    def with_attrs!(new_attrs)
      self.class.new(children, new_attrs)
    end

    # @yield Run the block once for each child
    # @yieldparam [Node] child one child
    # @yieldreturn [Node] a child to replace the one yielded to the block
    # @return [Node] a new node with the result of running the block once for
    #   each child
    def map_children
      return self if children.empty?
      self.with_children(children.map {|child| yield child })
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
    #   @param [Integer] index index of the child
    #   @return the child at +index+
    # @overload [](start, length)
    #   @param [Integer] start the index of the first child
    #   @param [Integer] length the number of children to return
    #   @return [Array] the node's children starting at +start+ and
    #     continuing for +length+ children
    # @overload [](range)
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
      (args.empty? and attrs.has_key?(symbol)) ? attrs[symbol] : super
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

    # @private
    def pretty_print(q) #:nodoc:
      pretty_print_name(q)
      q.group(1, '[', ']') do
        q.breakable('')
        q.seplist(children) {|_| q.pp _ }
        q.comma_breakable unless children.empty? or pretty_keys.empty?
        q.seplist(pretty_keys) do |k|
          q.pp k
          q.text '=>'
          q.pp attrs[k]
        end
      end
    end

    # @private
    def pretty_print_cycle(q) #:nodoc:
      pretty_print_name(q)
    end

    # @return a new +GraphViz+ digraph object representing the node
    def to_graphviz
      Rattler::Util::GraphViz.digraph(self)
    end

    private

    def pretty_print_name(q)
      q.text(self.class.name)
      q.text("<#{self.name.inspect}>") if attrs.has_key?(:name)
    end

    def pretty_keys
      @pretty_keys ||= attrs.keys.reject {|_| _ == :name }.sort_by {|_| _.to_s }
    end

  end
end
