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
