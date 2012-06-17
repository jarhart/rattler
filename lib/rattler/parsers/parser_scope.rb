require 'rattler/parsers'

module Rattler::Parsers

  # +ParserScope+ represents the scope of bindings and captures in a parse
  # sequence.
  class ParserScope

    # @return [ParserScope] an empty scope as a singleton
    def self.empty
      @empty ||= self.new
    end

    # @param [Hash] bindings labeled bindings
    # @param [Array] captures captured parse results
    # @param [Boolean] captures_decidable whether the list of captured parse
    #   results can be known statically
    def initialize(bindings={}, captures=[], captures_decidable=true)
      @bindings = bindings
      @captures = captures
      @captures_decidable = captures_decidable
    end

    attr_reader :bindings, :captures

    # @param [Hash] new_bindings bindings to add or replace the current
    #   bindings
    # @return [ParserScope] a new scope with additional bindings
    def bind(new_bindings)
      self.class.new(@bindings.merge(new_bindings), @captures, @captures_decidable)
    end

    # @param new_captures captures to add to the current captures
    # @return [ParserScope] a new scope with additional captures
    def capture(*new_captures)
      self.class.new(@bindings, @captures + new_captures, @captures_decidable)
    end

    # Create a new scope with this scope as the outer scope. The new scope
    # inherits this scope's bindings, but not its captures.
    #
    # @return [ParserScope] a new scope with this scope as the outer scope
    def nest
      self.class.new(@bindings, [], @captures_decidable)
    end

    # @param [ParserScope] other another scope
    # @return [ParserScope] a new scope with bindings the other scope
    def merge(other)
      bind(other.bindings)
    end

    # @return [ParserScope] a new scope with captures_decidable +false+
    def with_undecidable_captures
      if captures_decidable?
        self.class.new(@bindings, @captures, false)
      else
        self
      end
    end

    # @return whether the list of captured parse results can be known
    #   statically
    def captures_decidable?
      @captures_decidable
    end

    # @param [Symbol] name a binding name
    # @return whether the scope has a binding for +name+
    def has_name?(name)
      @bindings.has_key?(name)
    end

    # Run the block once for each binding
    # @yield [name, value] the binding name and value
    # @return self#bindings
    def each_binding
      @bindings.each {|name, value| yield name, value }
    end

    # @param [Symbol] name a binding name
    # @return the value bound to +name+ in the scope
    def [](name)
      @bindings[name]
    end

  end
end
