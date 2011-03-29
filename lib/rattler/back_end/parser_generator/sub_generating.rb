require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  module SubGenerating #:nodoc:

    include Rattler::Parsers

    protected

    def generate(parser, as=:basic, *args)
      gen_with generator(parser), parser, as, *args
    end

    def gen_nested(parser, as=:basic, *args)
      gen_with generator(parser, :nested), parser, as, *args
    end

    def gen_top_level(parser, as=:basic, *args)
      gen_with generator(parser, :top_level), parser, as, *args
    end

    def gen_eof
      @g << '@scanner.eos?'
    end

    private

    def gen_with(g, parser, as=:basic, *args)
      case parser
      when Eof then gen_eof
      else g.send(:"gen_#{as}", parser, *args)
      end
    end

    def generator(parser, context=nil)
      context ||= default_context

      case parser

      when Match
        cache_generator MatchGenerator, context

      when Choice
        cache_generator ChoiceGenerator, context, :new_choice_level => true

      when Sequence
        new_generator SequenceGenerator, context, :new_sequence_level => true

      when Optional
        cache_generator OptionalGenerator, context

      when ZeroOrMore
        cache_generator ZeroOrMoreGenerator, context, :new_repeat_level => true

      when OneOrMore
        cache_generator OneOrMoreGenerator, context, :new_repeat_level => true

      when Repeat
        cache_generator RepeatGenerator, context, :new_repeat_level => true

      when List0
        cache_generator ListGenerator, context, :new_repeat_level => true

      when List1
        cache_generator List1Generator, context, :new_repeat_level => true

      when Apply
        cache_generator ApplyGenerator, context

      when Assert
        cache_generator AssertGenerator, context

      when Disallow
        cache_generator DisallowGenerator, context

      when DispatchAction
        cache_generator DispatchActionGenerator, context

      when DirectAction
        cache_generator DirectActionGenerator, context

      when Token
        cache_generator TokenGenerator, context

      when Skip
        cache_generator SkipGenerator, context

      when Label
        cache_generator LabelGenerator, context

      when BackReference
        cache_generator BackReferenceGenerator, context

      when Fail
        cache_generator FailGenerator, context

      when GroupMatch
        cache_generator GroupMatchGenerator, context

      end
    end

    def cache_generator(factory, context, *args)
      generator_cache[context].fetch factory do
        generator_cache[factory] = new_generator factory, context, *args
      end
    end

    def new_generator(factory, context, opts = {})
      factory.send context, @g,
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
      @generator_cache ||= Hash.new {|h, k| h[k] = {} }
    end

  end

  module NestedSubGenerating
    include SubGenerating

    protected

    def default_context
      :nested
    end

    alias_method :factory_method, :default_context
  end

  module TopLevelSubGenerating
    include SubGenerating

    protected

    def default_context
      :top_level
    end

    alias_method :factory_method, :default_context
  end

end
