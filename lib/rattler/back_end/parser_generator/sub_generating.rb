require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  module SubGenerating #:nodoc:

    include Rattler::Parsers

    protected

    def generate(parser, as=:basic, *args)
      case parser
      when Eof then gen_eof
      else generator(parser).send(:"gen_#{as}", parser, *args)
      end
    end


    def gen_eof
      @g << '@scanner.eos?'
    end

    private

    def generator(parser)
      case parser

      when Match
        cache_generator MatchGenerator

      when Choice
        cache_generator ChoiceGenerator, :new_choice_level => true

      when Sequence
        new_generator SequenceGenerator, :new_sequence_level => true

      when Optional
        cache_generator OptionalGenerator

      when ZeroOrMore
        cache_generator ZeroOrMoreGenerator, :new_repeat_level => true

      when OneOrMore
        cache_generator OneOrMoreGenerator, :new_repeat_level => true

      when List0
        cache_generator ListGenerator, :new_repeat_level => true

      when List1
        cache_generator List1Generator, :new_repeat_level => true

      when Apply
        cache_generator ApplyGenerator

      when Assert
        cache_generator AssertGenerator

      when Disallow
        cache_generator DisallowGenerator

      when DispatchAction
        cache_generator DispatchActionGenerator

      when DirectAction
        cache_generator DirectActionGenerator

      when Token
        cache_generator TokenGenerator

      when Skip
        cache_generator SkipGenerator

      when Label
        cache_generator LabelGenerator

      when BackReference
        cache_generator BackReferenceGenerator

      when Fail
        cache_generator FailGenerator

      when GroupMatch
        cache_generator GroupMatchGenerator

      end
    end

    def cache_generator(factory, *args)
      generator_cache.fetch factory do
        generator_cache[factory] = new_generator factory, *args
      end
    end

    def new_generator(factory, opts = {})
      factory.send factory_method, @g,
        new_level(choice_level, opts[:new_choice_level]),
        new_level(sequence_level, opts[:new_sequence_level]),
        new_level(repeat_level, opts[:new_repeat_level])
    end

    def new_level(old_level, inc=true)
      if inc
        old_level ? (old_level + 1) : 0
      else
        old_level
      end
    end

    def generator_cache
      @generator_cache ||= {}
    end

  end

  module NestedSubGenerating
    include SubGenerating

    protected
    def factory_method
      :nested
    end
  end

  module TopLevelSubGenerating
    include SubGenerating

    protected
    def factory_method
      :top_level
    end
  end

end
