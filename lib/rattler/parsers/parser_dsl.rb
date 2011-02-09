#
# = rattler/parsers/parser_dsl.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler
  module Parsers
    #
    # +ParserDSL+ defines a simple DSL for defining parsers.
    #
    # @author Jason Arhart
    #
    class ParserDSL
      
      # Define parse rules with the given block
      #
      # @option options [Parser] ws (nil) a parser to be used to skip whitespace
      #
      # @return [Rattler::Parsers::Rules] a set of parse rules
      #
      def self.rules(options = {}, &block)
        self.new(options).rules(&block)
      end
      
      # @private
      def initialize(options = {}) #:nodoc:
        @rules = options[:rules] || []
        @options = options
        @ws = options[:ws]
      end
      
      # @private
      def with_options(options, &block) #:nodoc:
        dsl = self.class.new(@options.merge(:rules => @rules).merge(options))
        dsl.instance_exec(dsl, &block)
      end
      
      # Evaluate the given block using +ws+ to skip whitespace
      #
      # @param [Parser] ws the parser to be used to skip whitespace
      def with_ws(ws, &block)
        with_options(:ws => to_parser(ws), &block)
      end
      
      # Evaluate the given block to define parse rules
      #
      # @return [Rules] the rules defined in the block
      def rules(&block)
        instance_exec(self, &block)
        Rules[@rules]
      end
      
      # Evaluate the given block to define a parse rule
      #
      # @param [Symbol] name the name for the rule
      #
      # @return [Rule] the rule defined in the block
      def rule(name, &block)
        parser = instance_exec(self, &block)
        @rules << Rule[name, (@ws ? parser.with_ws(@ws) : parser)]
        @rules.last
      end
      
      # Create a new parser to match a pattern, literal, referenced parse rule,
      # posix character class, or EOF.
      #
      # @overload match(pattern)
      #   @param [Regexp] pattern the pattern to match
      #   @return [Match] a new match parser
      #
      # @overload match(literal)
      #   @param [String] literal the literal to match
      #   @return [Match] a new match parser that matches exactly +literal+
      #
      # @overload match(rule_name)
      #   @param [Symbol] rule_name the rule name to match
      #   @return [Apply] a new apply-rule parser
      #
      # @overload match(posix_name)
      #   @param [Symbol] posix_name upper-case name of a posix character class
      #   @return [Match] a new match parser that matches the character class
      #
      # @overload match(:EOF)
      #   @param :EOF
      #   @return [Eof] the {Eof} singleton
      #
      def match(arg)
        case arg
        when Regexp   then Match[arg]
        when :EOF     then eof
        when :ALNUM   then match /[[:alnum:]]/
        when :ALPHA   then match /[[:alpha:]]/
        when :BLANK   then match /[[:blank:]]/
        when :CNTRL   then match /[[:cntrl:]]/
        when :DIGIT   then match /[[:digit:]]/
        when :GRAPH   then match /[[:graph:]]/
        when :LOWER   then match /[[:lower:]]/
        when :PRINT   then match /[[:print:]]/
        when :PUNCT   then match /[[:punct:]]/
        when :SPACE   then match /[[:space:]]/
        when :UPPER   then match /[[:upper:]]/
        when :XDIGIT  then match /[[:xdigit:]]/
        when Symbol   then Apply[arg]
        else match Regexp.new(Regexp.escape(arg.to_s))
        end
      end
      
      # Create a new optional parser.
      #
      # @overload optional(parser)
      #   @return [Optional] a new optional parser
      # @overload optional(arg)
      #   @return [Optional] a new optional parser using arg to define a match
      #     parser
      #   @see #match
      def optional(arg)
        Optional[to_parser(arg)]
      end
      
      # Create a new zero-or-more parser.
      #
      # @overload zero_or_more(parser)
      #   @return [ZeroOrMore] a new zero-or-more parser
      # @overload zero_or_more(arg)
      #   @return [ZeroOrMore] a new zero-or-more parser using arg to define a
      #     match parser
      #   @see #match
      def zero_or_more(arg)
        ZeroOrMore[to_parser(arg)]
      end
      
      # Create a new one-or-more parser.
      #
      # @overload one_or_more(parser)
      #   @return [OneOrMore] a new one-or-more parser
      # @overload one_or_more(arg)
      #   @return [OneOrMore] a new one-or-more parser using arg to define a
      #     match parser
      #   @see #match
      def one_or_more(arg)
        OneOrMore[to_parser(arg)]
      end
      
      # Create a new assert parser.
      #
      # @overload assert(parser)
      #   @return [Assert] a new assert parser
      # @overload assert(arg)
      #   @return [Assert] a new assert parser using arg to define a match
      #     parser
      #   @see #match
      def assert(arg)
        Assert[to_parser(arg)]
      end
      
      # Create a new disallow parser.
      #
      # @overload disallow(parser)
      #   @return [Disallow] a new disallow parser
      # @overload disallow(arg)
      #   @return [Disallow] a new disallow parser using arg to define a match
      #     parser
      #   @see #match
      def disallow(arg)
        Disallow[to_parser(arg)]
      end
      
      # @return the eof parser
      def eof
        Eof[]
      end
      
      # Create a new symantic action that dispatches to a method.
      #
      # @overload dispatch_action(parser)
      #   @return [DispatchAction] a new symantic action
      # @overload dispatch_action(arg)
      #   @return [DispatchAction] a new symantic action using arg to define a
      #     match parser
      #   @see #match
      def dispatch_action(arg, attrs={})
        DispatchAction[to_parser(arg), attrs]
      end
      
      # alias action dispatch_action
      
      # Create a new symantic action that evaluates ruby code.
      #
      # @overload direct_action(parser, code)
      #   @return [DirectAction] a new symantic action
      # @overload direct_action(arg, code)
      #   @return [DirectAction] a new symantic action using arg to define a
      #     match parser
      #   @see #match
      def direct_action(arg, code)
        DirectAction[to_parser(arg), code]
      end
      
      # Create a new token parser or token rule.
      #
      # @overload token(rule_name, &block)
      #   @return [Rule] a new token rule
      # @overload token(parser)
      #   @return [Token] a new token parser
      # @overload token(arg)
      #   @return [Token] a new token parser using arg to define a match parser
      #   @see #match
      def token(arg, &block)
        if block_given?
          rule(arg) { token(instance_exec(self, &block)) }
        else
          Token[to_parser(arg)]
        end
      end
      
      # Create a new skip parser.
      #
      # @overload skip(parser)
      #   @return [Skip] a new skip parser
      # @overload skip(arg)
      #   @return [Skip] a new skip parser using arg to define a match
      #     parser
      #   @see #match
      def skip(arg)
        Skip[to_parser(arg)]
      end
      
      # Create a new labeled parser.
      #
      # @overload label(parser)
      #   @return [Label] a new labeled parser
      # @overload label(arg)
      #   @return [Label] a new labeled parser using arg to define a match
      #     parser
      #   @see #match
      def label(name, arg)
        Label[name, to_parser(arg)]
      end
      
      # @return [Fail] a parser that always fails
      def fail(message)
        Fail[:expr, message]
      end
      
      # @return [Fail] a parser that fails the entire rule
      def fail_rule(message)
        Fail[:rule, message]
      end
      
      # @return [Fail] a parser that fails the entire parse
      def fail_parse(message)
        Fail[:parse, message]
      end
      
      # @return [Match] a parser matching any character
      def any
        match /./
      end
      
      # @return [Match] a parser matching the POSIX +alnum+ character class
      def alnum
        match :ALNUM
      end
      
      # @return [Match] a parser matching the POSIX +alpha+ character class
      def alpha
        match :ALPHA
      end
      
      # @return [Match] a parser matching the POSIX +blank+ character class
      def blank
        match :BLANK
      end
      
      # @return [Match] a parser matching the POSIX +cntrl+ character class
      def cntrl
        match :CNTRL
      end
      
      # @return [Match] a parser matching the POSIX +digit+ character class
      def digit
        match :DIGIT
      end
      
      # @return [Match] a parser matching the POSIX +graph+ character class
      def graph
        match :GRAPH
      end
      
      # @return [Match] a parser matching the POSIX +lower+ character class
      def lower
        match :LOWER
      end
      
      # @return [Match] a parser matching the POSIX +print+ character class
      def print
        match :PRINT
      end
      
      # @return [Match] a parser matching the POSIX +punct+ character class
      def punct
        match :PUNCT
      end
      
      # @return [Match] a parser matching the POSIX +space+ character class
      def space
        match :SPACE
      end
      
      # @return [Match] a parser matching the POSIX +upper+ character class
      def upper
        match :UPPER
      end
      
      # @return [Match] a parser matching the POSIX +xdigit+ character class
      def xdigit
        match :XDIGIT
      end
      
      private
      
      def to_parser(o)
        case o
        when Parser then o
        when nil    then nil
        when false  then nil
        else match(o)
        end
      end
      
    end
  end
end
