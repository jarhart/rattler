require 'rattler/compiler/parser_generator'

module Rattler::Compiler::ParserGenerator

  # @private
  class RepeatGenerator < DelegatingGenerator #:nodoc:
    include NestedSubGenerating

    protected

    def impl(repeat, init_args)
      generator = default_impl(repeat, init_args)
      specialize_for repeat, generator
      generator
    end

    def specialize_for(repeat, generator)
      return unless repeat.respond_to? :lower_bound
      if repeat.lower_bound == 0
        if repeat.upper_bound == 1
          generator.extend OptionalGenerating
        else
          generator.extend ZeroOrMoreGenerating
        end
      elsif repeat.lower_bound == 1
        generator.extend OneOrMoreGenerating
      end
    end
  end

  # @private
  class NestedRepeatGenerator < RepeatGenerator #:nodoc:
    def default_impl(list, init_args)
      GeneralRepeatGenerator.nested(*init_args)
    end
  end

  def RepeatGenerator.nested(*args)
    NestedRepeatGenerator.new(*args)
  end

  # @private
  class TopLevelRepeatGenerator < RepeatGenerator #:nodoc:
    def default_impl(list, init_args)
      GeneralRepeatGenerator.top_level(*init_args)
    end
  end

  def RepeatGenerator.top_level(*args)
    TopLevelRepeatGenerator.new(*args)
  end

end
