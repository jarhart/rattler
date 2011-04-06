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

    autoload :RuleSetGenerator, 'rattler/back_end/parser_generator/rule_set_generator'
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
    autoload :RepeatGenerator, 'rattler/back_end/parser_generator/repeat_generator'
    autoload :GeneralRepeatGenerator, 'rattler/back_end/parser_generator/general_repeat_generator'
    autoload :ListGenerator, 'rattler/back_end/parser_generator/list_generator'
    autoload :GeneralListGenerator, 'rattler/back_end/parser_generator/general_list_generator'
    autoload :ApplyGenerator, 'rattler/back_end/parser_generator/apply_generator'
    autoload :AssertGenerator, 'rattler/back_end/parser_generator/assert_generator'
    autoload :DisallowGenerator, 'rattler/back_end/parser_generator/disallow_generator'
    autoload :DispatchActionGenerator, 'rattler/back_end/parser_generator/dispatch_action_generator'
    autoload :DirectActionGenerator, 'rattler/back_end/parser_generator/direct_action_generator'
    autoload :TokenGenerator, 'rattler/back_end/parser_generator/token_generator'
    autoload :SkipGenerator, 'rattler/back_end/parser_generator/skip_generator'
    autoload :LabelGenerator, 'rattler/back_end/parser_generator/label_generator'
    autoload :BackReferenceGenerator, 'rattler/back_end/parser_generator/back_reference_generator'
    autoload :FailGenerator, 'rattler/back_end/parser_generator/fail_generator'
    autoload :DelegatingGenerator, 'rattler/back_end/parser_generator/delegating_generator'
    autoload :ZeroOrMoreGenerating, 'rattler/back_end/parser_generator/zero_or_more_generating'
    autoload :OptionalGenerating, 'rattler/back_end/parser_generator/optional_generating'
    autoload :OneOrMoreGenerating, 'rattler/back_end/parser_generator/one_or_more_generating'
    autoload :List0Generating, 'rattler/back_end/parser_generator/list0_generating'
    autoload :List1Generating, 'rattler/back_end/parser_generator/list1_generating'
    autoload :PredicatePropogating, 'rattler/back_end/parser_generator/predicate_propogating'
    autoload :TokenPropogating, 'rattler/back_end/parser_generator/token_propogating'
    autoload :SkipPropogating, 'rattler/back_end/parser_generator/skip_propogating'
    autoload :GroupMatchGenerator, 'rattler/back_end/parser_generator/group_match_generator'
    autoload :GroupMatch, 'rattler/back_end/parser_generator/group_match'
    autoload :GEN_METHOD_NAMES, 'rattler/back_end/parser_generator/gen_method_names'

    # Generate parsing code for a parser model using a ruby generator +g+.
    #
    # @overload generate(g, grammar)
    #   @param [RubyGenerator] g the ruby generator to use
    #   @param [Rattler::Grammar::Grammar] grammar the grammar model
    #   @return g
    #
    # @overload generate(g, rules)
    #   @param [RubyGenerator] g the ruby generator to use
    #   @param [Rules] rules the parse rules
    #   @return g
    #
    # @overload generate(g, rule)
    #   @param [RubyGenerator] g the ruby generator to use
    #   @param [Rule] rule the parse rule
    #   @return g
    #
    # @overload generate(g, parser)
    #   @param [RubyGenerator] g the ruby generator to use
    #   @param [Parser] parser the parser model
    #   @return g
    #
    def self.generate(g, parser, opts={})
      unless opts[:no_optimize]
        parser = ::Rattler::BackEnd::Optimizer.optimize(parser, opts)
      end
      RuleSetGenerator.new(g).generate(parser, opts)
      g
    end

    # Generate parsing code for +parser+ using a new {RubyGenerator} with the
    # given options and return the generated code.
    #
    # @overload code_for(grammar, opts)
    #   @param [Rattler::Grammar::Grammar] grammar the grammar model
    #   @return [String] the generated code
    #
    # @overload code_for(rules, opts)
    #   @param [Rules] rules the parse rules
    #   @return [String] the generated code
    #
    # @overload code_for(rule, opts)
    #   @param [Rule] rule the parse rule
    #   @return [String] the generated code
    #
    # @overload code_for(parser, opts)
    #   @param [Parser] parser the parser model
    #   @return [String] the generated code
    #
    def self.code_for(parser, opts={})
      ::Rattler::BackEnd::RubyGenerator.code(opts) {|g| generate g, parser, opts }
    end

  end
end
