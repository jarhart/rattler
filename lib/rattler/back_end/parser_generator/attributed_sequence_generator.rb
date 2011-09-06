require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class AttributedSequenceGenerator < ExprGenerator #:nodoc:
    include SequenceGenerating

    def gen_basic(sequence, scope = ParserScope.empty)
      with_backtracking do
        gen_children_capturing(sequence, scope.nest) do |last_child, scope|
          gen_nested last_child, :basic, scope
        end
      end
    end

  end

  # @private
  class NestedAttributedSequenceGenerator < AttributedSequenceGenerator #:nodoc:
    include Nested
  end

  def AttributedSequenceGenerator.nested(*args)
    NestedAttributedSequenceGenerator.new(*args)
  end

  # @private
  class TopLevelAttributedSequenceGenerator < AttributedSequenceGenerator #:nodoc:
    include TopLevel
  end

  def AttributedSequenceGenerator.top_level(*args)
    TopLevelAttributedSequenceGenerator.new(*args)
  end

end
