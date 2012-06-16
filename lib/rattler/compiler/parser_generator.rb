#
# = rattler/compiler/parser_generator.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#
require 'rattler/compiler'

module Rattler::Compiler
  #
  # A +ParserGenerator+ generates ruby parsing code from parser models.
  #
  # @author Jason Arhart
  #
  module ParserGenerator

    autoload :GrammarGenerator, 'rattler/compiler/parser_generator/grammar_generator'
    autoload :RuleSetGenerator, 'rattler/compiler/parser_generator/rule_set_generator'
    autoload :RuleGenerator, 'rattler/compiler/parser_generator/rule_generator'
    autoload :ExprGenerator, 'rattler/compiler/parser_generator/expr_generator'
    autoload :GeneratorHelper, 'rattler/compiler/parser_generator/generator_helper'
    autoload :NestedExprGenerator, 'rattler/compiler/parser_generator/expr_generator'
    autoload :SubGenerating, 'rattler/compiler/parser_generator/sub_generating'
    autoload :NestedSubGenerating, 'rattler/compiler/parser_generator/sub_generating'
    autoload :TopLevelSubGenerating, 'rattler/compiler/parser_generator/sub_generating'
    autoload :Nested, 'rattler/compiler/parser_generator/nested'
    autoload :TopLevel, 'rattler/compiler/parser_generator/top_level'
    autoload :MatchGenerator, 'rattler/compiler/parser_generator/match_generator'
    autoload :ChoiceGenerator, 'rattler/compiler/parser_generator/choice_generator'
    autoload :SequenceGenerator, 'rattler/compiler/parser_generator/sequence_generator'
    autoload :RepeatGenerator, 'rattler/compiler/parser_generator/repeat_generator'
    autoload :GeneralRepeatGenerator, 'rattler/compiler/parser_generator/general_repeat_generator'
    autoload :ListGenerator, 'rattler/compiler/parser_generator/list_generator'
    autoload :GeneralListGenerator, 'rattler/compiler/parser_generator/general_list_generator'
    autoload :ApplyGenerator, 'rattler/compiler/parser_generator/apply_generator'
    autoload :AssertGenerator, 'rattler/compiler/parser_generator/assert_generator'
    autoload :DisallowGenerator, 'rattler/compiler/parser_generator/disallow_generator'
    autoload :EofGenerator, 'rattler/compiler/parser_generator/eof_generator'
    autoload :ESymbolGenerator, 'rattler/compiler/parser_generator/e_symbol_generator'
    autoload :SemanticActionGenerator, 'rattler/compiler/parser_generator/semantic_action_generator'
    autoload :NodeActionGenerator, 'rattler/compiler/parser_generator/node_action_generator'
    autoload :AttributedSequenceGenerator, 'rattler/compiler/parser_generator/attributed_sequence_generator'
    autoload :TokenGenerator, 'rattler/compiler/parser_generator/token_generator'
    autoload :SkipGenerator, 'rattler/compiler/parser_generator/skip_generator'
    autoload :SuperGenerator, 'rattler/compiler/parser_generator/super_generator'
    autoload :LabelGenerator, 'rattler/compiler/parser_generator/label_generator'
    autoload :BackReferenceGenerator, 'rattler/compiler/parser_generator/back_reference_generator'
    autoload :FailGenerator, 'rattler/compiler/parser_generator/fail_generator'
    autoload :DelegatingGenerator, 'rattler/compiler/parser_generator/delegating_generator'
    autoload :SequenceGenerating, 'rattler/compiler/parser_generator/sequence_generating'
    autoload :ZeroOrMoreGenerating, 'rattler/compiler/parser_generator/zero_or_more_generating'
    autoload :OptionalGenerating, 'rattler/compiler/parser_generator/optional_generating'
    autoload :OneOrMoreGenerating, 'rattler/compiler/parser_generator/one_or_more_generating'
    autoload :List0Generating, 'rattler/compiler/parser_generator/list0_generating'
    autoload :List1Generating, 'rattler/compiler/parser_generator/list1_generating'
    autoload :PredicatePropogating, 'rattler/compiler/parser_generator/predicate_propogating'
    autoload :TokenPropogating, 'rattler/compiler/parser_generator/token_propogating'
    autoload :SkipPropogating, 'rattler/compiler/parser_generator/skip_propogating'
    autoload :GroupMatchGenerator, 'rattler/compiler/parser_generator/group_match_generator'
    autoload :GroupMatch, 'rattler/compiler/parser_generator/group_match'
    autoload :GEN_METHOD_NAMES, 'rattler/compiler/parser_generator/gen_method_names'

    # Generate parsing code for a parser model using a ruby generator +g+.
    #
    # @overload generate(g, grammar)
    #   @param [RubyGenerator] g the ruby generator to use
    #   @param [Rattler::Parsers::Grammar] grammar the grammar model
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
        parser = ::Rattler::Compiler::Optimizer.optimize(parser, opts)
      end
      GrammarGenerator.new(g).generate(parser, opts)
      g
    end

    # Generate parsing code for +parser+ using a new {RubyGenerator} with the
    # given options and return the generated code.
    #
    # @overload code_for(grammar, opts)
    #   @param [Rattler::Parsers::Grammar] grammar the grammar model
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
      ::Rattler::Compiler::RubyGenerator.code(opts) {|g| generate g, parser, opts }
    end

  end
end
