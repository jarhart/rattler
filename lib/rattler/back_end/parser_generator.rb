#
# = rattler/back_end/parser_generator.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/back_end'

module Rattler::BackEnd
  #
  # A +ParserGenerator+ generates ruby parsing code from parser models.
  #
  # @author Jason Arhart
  #
  module ParserGenerator

    autoload :RuleGenerator, 'rattler/back_end/parser_generator/rule_generator'
    autoload :ExprGenerator, 'rattler/back_end/parser_generator/expr_generator'
    autoload :GeneratorHelper, 'rattler/back_end/parser_generator/generator_helper'
    autoload :TopLevelGenerator, 'rattler/back_end/parser_generator/expr_generator'
    autoload :SubGenerating, 'rattler/back_end/parser_generator/sub_generating'
    autoload :NestedSubGenerating, 'rattler/back_end/parser_generator/sub_generating'
    autoload :TopLevelSubGenerating, 'rattler/back_end/parser_generator/sub_generating'
    autoload :Nested, 'rattler/back_end/parser_generator/nested'
    autoload :TopLevel, 'rattler/back_end/parser_generator/top_level'
    autoload :MatchGenerator, 'rattler/back_end/parser_generator/match_generator'
    autoload :ChoiceGenerator, 'rattler/back_end/parser_generator/choice_generator'
    autoload :SequenceGenerator, 'rattler/back_end/parser_generator/sequence_generator'
    autoload :OptionalGenerator, 'rattler/back_end/parser_generator/optional_generator'
    autoload :ZeroOrMoreGenerator, 'rattler/back_end/parser_generator/zero_or_more_generator'
    autoload :OneOrMoreGenerator, 'rattler/back_end/parser_generator/one_or_more_generator'
    autoload :ListGenerator, 'rattler/back_end/parser_generator/list_generator'
    autoload :List1Generator, 'rattler/back_end/parser_generator/list1_generator'
    autoload :ApplyGenerator, 'rattler/back_end/parser_generator/apply_generator'
    autoload :AssertGenerator, 'rattler/back_end/parser_generator/assert_generator'
    autoload :DisallowGenerator, 'rattler/back_end/parser_generator/disallow_generator'
    autoload :DispatchActionGenerator, 'rattler/back_end/parser_generator/dispatch_action_generator'
    autoload :DirectActionGenerator, 'rattler/back_end/parser_generator/direct_action_generator'
    autoload :TokenGenerator, 'rattler/back_end/parser_generator/token_generator'
    autoload :SkipGenerator, 'rattler/back_end/parser_generator/skip_generator'
    autoload :LabelGenerator, 'rattler/back_end/parser_generator/label_generator'
    autoload :FailGenerator, 'rattler/back_end/parser_generator/fail_generator'
    autoload :RepeatGenerating, 'rattler/back_end/parser_generator/repeat_generating'
    autoload :ListGenerating, 'rattler/back_end/parser_generator/list_generating'
    autoload :PredicatePropogating, 'rattler/back_end/parser_generator/predicate_propogating'
    autoload :TokenPropogating, 'rattler/back_end/parser_generator/token_propogating'
    autoload :SkipPropogating, 'rattler/back_end/parser_generator/skip_propogating'
    autoload :GEN_METHOD_NAMES, 'rattler/back_end/parser_generator/gen_method_names'

    # Generate parsing code for a parser model using a ruby generator +g+.
    #
    # @overload generate(g, grammar)
    #   @param [RubyGenerator] g the ruby generator to use
    #   @param [Rattler::Grammar::Grammar] grammar the grammar model
    #   @return nil
    #
    # @overload generate(g, rules)
    #   @param [RubyGenerator] g the ruby generator to use
    #   @param [Rules] rules the parse rules
    #   @return nil
    #
    # @overload generate(g, rule)
    #   @param [RubyGenerator] g the ruby generator to use
    #   @param [Rule] rule the parse rule
    #   @return nil
    #
    # @overload generate(g, parser)
    #   @param [RubyGenerator] g the ruby generator to use
    #   @param [Parser] parser the parser model
    #   @return nil
    #
    def self.generate(g, parser)
      RuleGenerator.new(g).generate(parser)
      nil
    end

    # Generate parsing code for +parser+ using a new {RubyGenerator} with the
    # given options and return the generated code.
    #
    # @overload code_for(grammar, options)
    #   @param [Rattler::Grammar::Grammar] grammar the grammar model
    #   @return [String] the generated code
    #
    # @overload code_for(rules, options)
    #   @param [Rules] rules the parse rules
    #   @return [String] the generated code
    #
    # @overload code_for(rule, options)
    #   @param [Rule] rule the parse rule
    #   @return [String] the generated code
    #
    # @overload code_for(parser, options)
    #   @param [Parser] parser the parser model
    #   @return [String] the generated code
    #
    def self.code_for(parser, options={})
      ::Rattler::BackEnd::RubyGenerator.code(options) {|g| generate(g, parser) }
    end

  end
end