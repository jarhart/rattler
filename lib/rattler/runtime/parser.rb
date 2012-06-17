require 'rattler/runtime'
require 'strscan'

module Rattler::Runtime

  # +Parser+ is the base class for all parsers in the Rattler framework.
  class Parser < Rattler::Util::Node

    # Parse +source+ and raise a {SyntaxError} if the parse fails.
    #
    # @param (see #initialize)
    # @raise (see #parse!)
    # @return (see #parse!)
    def self.parse!(source, options={})
      self.new(source, options).parse!
    end

    # Parse the entirety of +source+ and raise a {SyntaxError} if the parse
    # fails.
    #
    # @param (see #initialize)
    # @raise (see #parse!)
    # @return (see #parse!)
    def self.parse_fully!(source, options={})
      self.new(source, options).parse_fully!
    end

    # Create a new parser to parse +source+.
    #
    # @param [String] source the source to parse
    # @option options [Integer] :tab_size (8) tab size to use to calculate
    #   column numbers
    def initialize(source, options={})
      @source = source
      @scanner = StringScanner.new(source)
      @tab_size = options[:tab_size]
    end

    # @return [String] the source that this parser parses
    attr_reader :source

    # Parse or register a parse failure
    #
    # @return the parse result
    def parse
      catch(:parse_failed) { return finish __parse__ }
      false
    end

    # Parse or raise a {SyntaxError}
    #
    # @raise [SyntaxError] a {SyntaxError} if the parse fails
    #
    # @return (see #parse)
    def parse!
      parse or raise_error
    end

    # Parse the entire source or register a parse failure
    #
    # @return the parse result if the entire source was matched
    def parse_fully
      (result = parse) && (@scanner.eos? || fail { :EOF }) && result
    end

    # Parse the entire source or raise a {SyntaxError}
    #
    # @raise [SyntaxError] a {SyntaxError} if the parse fails or the entire
    #   source is not matched
    #
    # @return (see #parse_fully)
    def parse_fully!
      parse_fully or raise_error
    end

    # @return [Fixnum] the current parse position
    def pos
      @scanner.pos
    end

    # Set the current parse position
    # @param [Integer] n the new parse position
    # @return [Fixnum] the new parse position
    def pos=(n)
      @scanner.pos = n
    end

    # Fail and register a parse failure, unless a failure has already
    # occurred at the same or later position in the source.
    #
    # @yieldreturn [String, Symbol] a failure message or rule name
    #
    # @see ParseFailure
    #
    # @return [false]
    def fail # :yield:
      pos = @scanner.pos
      unless failure? and @failure_pos >= pos
        register_failure pos, (block_given? ? yield : nil)
      end
    end

    # Fail and register a parse failure, unless a failure has already
    # occurred at a later position in the source.
    #
    # @yieldreturn (see #fail)
    #
    # @return (see #fail)
    def fail! # :yield:
      pos = @scanner.pos
      unless failure? and @failure_pos > pos
        register_failure pos, (block_given? ? yield : nil)
      end
    end

    # Fail the same as <tt>#fail</tt> but cause the entire parse to fail
    # immediately.
    #
    # @yieldreturn (see #fail)
    #
    # @return (see #fail)
    def fail_parse
      if block_given?
        fail! { yield }
      else
        fail!
      end
      throw :parse_failed
    end

    # Return true if there is a parse failure
    # @return [Boolean] true if there is a parse failure
    def failure?
      !@failure_pos.nil?
    end

    # Return the last parse failure
    # @return [ParseFailure] the last parse failure
    def failure
      if failure?
        @__failure__ ||= ParseFailure.new(source, @failure_pos, @failure_msg)
      end
    end

    protected

    # Finish any necessary clean-up based on the final parse result.
    # @param final_result the final parse result
    # @return final_result
    def finish(final_result)
      clear_failure if final_result
      final_result
    end

    # Register a parse failure
    #
    # @param [Integer] position the position of the failure
    # @param [String, Symbol] message a failure message or rule name or +nil+
    #
    # @return [false]
    def register_failure(position, message)
      @failure_pos = position
      @failure_msg = message
      @__failure__ = nil
      false
    end

    # Clear the registered failure
    def clear_failure
      @failure_pos = nil
      @failure_msg = nil
      @__failure__ = nil
    end

    # Raise a {SyntaxError} for the last parse failure
    # @raise [SyntaxError] a {SyntaxError} for the last parse failure
    # @return [nothing]
    def raise_error
      raise SyntaxError, failure.to_s
    end

  end
end
