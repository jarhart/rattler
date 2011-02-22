require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class ExprGenerator #:nodoc:
    include GeneratorHelper

    include Rattler::Parsers

    def initialize(g, choice_level=nil, sequence_level=nil, repeat_level=nil)
      @g = g
      @choice_level = choice_level
      @sequence_level = sequence_level
      @repeat_level = repeat_level
    end

    def generate(parser, gen_method=:gen_basic, *args)
      case parser
      when Eof then gen_eof
      else generator(parser).send(gen_method, parser, *args)
      end
    end

    def gen_eof
      @g << '@scanner.eos?'
    end

    private

    def generator(parser)
      case parser
      when Match          then match_generator
      when Choice         then choice_generator
      when Sequence       then sequence_generator
      when Optional       then optional_generator
      when ZeroOrMore     then zero_or_more_generator
      when OneOrMore      then one_or_more_generator
      when List           then list_generator
      when List1          then list1_generator
      when Apply          then apply_generator
      when Assert         then assert_generator
      when Disallow       then disallow_generator
      when DispatchAction then dispatch_action_generator
      when DirectAction   then direct_action_generator
      when Token          then token_generator
      when Skip           then skip_generator
      when Label          then label_generator
      when Fail           then fail_generator
      end
    end

    attr_reader :choice_level, :sequence_level, :repeat_level

  end

  # @private
  class TopLevelGenerator < ExprGenerator #:nodoc:
    include TopLevelGenerators
  end

end
