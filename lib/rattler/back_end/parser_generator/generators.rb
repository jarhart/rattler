require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  module Generators #:nodoc:

    protected

    def match_generator
      @match_generator ||= MatchGenerator.send(factory_method, @g,
        choice_level, sequence_level, repeat_level)
    end

    def choice_generator
      ChoiceGenerator.send(factory_method, @g,
        new_level(choice_level), sequence_level, repeat_level)
    end

    def sequence_generator
      SequenceGenerator.send(factory_method, @g,
        choice_level, new_level(sequence_level), repeat_level)
    end

    def optional_generator
      @optional_generator ||= OptionalGenerator.send(factory_method, @g,
        choice_level, sequence_level, repeat_level)
    end

    def zero_or_more_generator
      ZeroOrMoreGenerator.send(factory_method, @g,
        choice_level, sequence_level, new_level(repeat_level))
    end

    def one_or_more_generator
      OneOrMoreGenerator.send(factory_method, @g,
        choice_level, sequence_level, new_level(repeat_level))
    end

    def list_generator
      ListGenerator.send(factory_method, @g,
        choice_level, sequence_level, new_level(repeat_level))
    end

    def list1_generator
      List1Generator.send(factory_method, @g,
        choice_level, sequence_level, new_level(repeat_level))
    end

    def apply_generator
      @apply_generator ||= ApplyGenerator.send(factory_method, @g,
        choice_level, sequence_level, repeat_level)
    end

    def assert_generator
      @assert_generator ||= AssertGenerator.send(factory_method, @g,
        choice_level, sequence_level, repeat_level)
    end

    def disallow_generator
      @disallow_generator ||= DisallowGenerator.send(factory_method, @g,
        choice_level, sequence_level, repeat_level)
    end

    def dispatch_action_generator
      @dispatch_action_generator ||= DispatchActionGenerator.send(factory_method, @g,
        choice_level, sequence_level, repeat_level)
    end

    def direct_action_generator
      @direct_action_generator ||= DirectActionGenerator.send(factory_method, @g,
        choice_level, sequence_level, repeat_level)
    end

    def token_generator
      @token_generator ||= TokenGenerator.send(factory_method, @g,
        choice_level, sequence_level, repeat_level)
    end

    def skip_generator
      @skip_generator ||= SkipGenerator.send(factory_method, @g,
        choice_level, sequence_level, repeat_level)
    end

    def label_generator
      @label_generator ||= LabelGenerator.send(factory_method, @g,
        choice_level, sequence_level, repeat_level)
    end

    def fail_generator
      @fail_generator ||= FailGenerator.send(factory_method, @g)
    end

  end

end
