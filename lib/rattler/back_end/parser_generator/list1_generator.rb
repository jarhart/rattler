require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class List1Generator < ExprGenerator #:nodoc:
    include ListGenerating
    include NestedSubGenerating
    include PredicatePropogating

    def gen_skip_top_level(list)
      (@g << "#{result_name} = false").newline
      (@g << "#{saved_pos_name} = nil").newline
      @g << 'while '
      generate list.child, :intermediate_skip
      @g.block '' do
        (@g << "#{result_name} = true").newline
        (@g << "#{saved_pos_name} = @scanner.pos").newline
        @g << 'break unless '
        generate list.sep_parser, :intermediate_skip
      end.newline
      @g << "@scanner.pos = #{saved_pos_name} unless #{saved_pos_name}.nil?"
      @g.newline << result_name
    end

    protected

    def gen_result(captures)
      @g << captures << " unless #{accumulator_name}.empty?"
    end

  end

  # @private
  class NestedList1Generator < List1Generator #:nodoc:
    include Nested
  end

  def List1Generator.nested(*args)
    NestedList1Generator.new(*args)
  end

  # @private
  class TopLevelList1Generator < List1Generator #:nodoc:
    include TopLevel

    def gen_assert(parser)
      generate parser.child, :assert_top_level
    end

    def gen_disallow(parser)
      generate parser.child, :disallow_top_level
    end

  end

  def List1Generator.top_level(*args)
    TopLevelList1Generator.new(*args)
  end

end
