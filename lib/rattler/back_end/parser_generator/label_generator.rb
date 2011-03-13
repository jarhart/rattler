require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class LabelGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating

    def gen_basic(label, scope={})
      generate label.child, :basic, scope
    end

    def gen_dispatch_action(label, code, scope={})
      generate label.child, :dispatch_action, code, scope
    end

    def gen_direct_action_nested(label, code, scope={})
      atomic_block { gen_direct_action_top_level label, code, scope }
    end

    def gen_direct_action_top_level(label, code, scope={})
      scope = gen_capturing label.child, scope, label.label
      (@g << ' &&').newline << '(' << code.bind(scope, [result_name]) << ')'
    end

    private

    def gen_capturing(child, scope, label)
      if child.capturing?
        @g.surround("(#{result_name} = ", ')') do
          generate child, :basic_nested, scope
        end
        scope.merge(label => result_name)
      else
        generate child, :intermediate, scope
        scope
      end
    end

  end

  # @private
  class NestedLabelGenerator < LabelGenerator #:nodoc:
    include Nested
    include NestedSubGenerating
  end

  def LabelGenerator.nested(*args)
    NestedLabelGenerator.new(*args)
  end

  # @private
  class TopLevelLabelGenerator < LabelGenerator #:nodoc:
    include TopLevel
    include TopLevelSubGenerating
  end

  def LabelGenerator.top_level(*args)
    TopLevelLabelGenerator.new(*args)
  end

end
