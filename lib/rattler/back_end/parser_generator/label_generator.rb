require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class LabelGenerator < ExprGenerator #:nodoc:
    include PredicatePropogating
    include TokenPropogating
    include SkipPropogating

    def gen_basic(label, scope = ParserScope.empty)
      generate label.child, :basic, scope
    end

    def gen_dispatch_action(label, code, scope = ParserScope.empty)
      expr :block do
        scope = gen_capturing label.child, scope, label.label
        (@g << ' &&').newline << code.bind(scope, dispatch_action_args)
      end
    end

    def gen_direct_action(label, code, scope = ParserScope.empty)
      expr :block do
        scope = gen_capturing label.child, scope, label.label
        (@g << ' &&').newline
        @g.surround('(', ')') { @g << code.bind(scope.capture(*direct_action_args)) }
      end
    end

    private

    def gen_capturing(child, scope, label)
      if child.capturing?
        gen_capture { gen_nested child, :basic, scope }
        scope.bind(label => result_name)
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
