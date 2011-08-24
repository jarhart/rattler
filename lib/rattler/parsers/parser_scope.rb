require 'rattler/parsers'

module Rattler::Parsers
  #
  # +ParserScope+ represents the scope of bindings and captures in a parse
  # sequence.
  #
  class ParserScope

    def self.empty
      @empty ||= self.new
    end

    def initialize(bindings={}, captures=[])
      @bindings = bindings
      @captures = captures
    end

    attr_reader :bindings, :captures

    # Create a new scope with additional bindings.
    #
    # @return [ParserScope] a new scope with additional bindings
    def bind(new_bindings)
      self.class.new(@bindings.merge(new_bindings), @captures)
    end

    # Create a new scope with additional captures.
    #
    # @return [ParserScope] a new scope with additional captures
    def capture(*new_captures)
      self.class.new(@bindings, @captures + new_captures)
    end

    # Create a new scope with this scope as the outer scope. The new scope
    # inherits this scope's bindings, but not its captures.
    #
    # @return [ParserScope] a new scope with this scope as the outer scope
    def nest
      self.class.new(@bindings)
    end

    # Create a new scope with bindings from another scope.
    #
    # @return [ParserScope] a new scope with bindings from another scope
    def merge(other)
      bind(other.bindings)
    end

    def has_name?(name)
      @bindings.has_key?(name)
    end

    def each_binding
      @bindings.each {|name, value| yield name, value }
    end

    def [](name)
      @bindings[name]
    end

  end
end
