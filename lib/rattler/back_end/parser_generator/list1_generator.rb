require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class List1Generator < ExprGenerator #:nodoc:
    include ListGenerating
    include NestedSubGenerating
    include PredicatePropogating

    def gen_skip(list, scope={})
      expr :block do
        (@g << "#{result_name} = false").newline
        gen_skipping(list, scope) { (@g << "#{result_name} = true").newline }
        @g.newline << result_name
      end
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

    def gen_assert(parser, scope = {})
      gen_top_level parser.child, :assert, scope
    end

    def gen_disallow(parser, scope = {})
      gen_top_level parser.child, :disallow, scope
    end

  end

  def List1Generator.top_level(*args)
    TopLevelList1Generator.new(*args)
  end

end
