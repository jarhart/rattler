require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class ListGenerator < ExprGenerator #:nodoc:
    include ListGenerating

    def gen_assert(optional)
      @g << 'true'
    end

    def gen_disallow(optional)
      @g << 'false'
    end

    def gen_skip_top_level(list)
      (@g << "#{saved_pos_name} = nil").newline
      @g << 'while '
      generate list.child, :gen_intermediate_skip
      @g.block '' do
        (@g << "#{saved_pos_name} = @scanner.pos").newline
        @g << 'break unless '
        generate list.sep_parser, :gen_intermediate_skip
      end.newline
      @g << "@scanner.pos = #{saved_pos_name} unless #{saved_pos_name}.nil?"
      @g.newline << true
    end

    protected

    def gen_result(captures)
      @g << captures
    end

  end

  # @private
  class NestedListGenerator < ListGenerator #:nodoc:
    include Nested
    include NestedGenerators
  end

  def ListGenerator.nested(*args)
    NestedListGenerator.new(*args)
  end

  # @private
  class TopLevelListGenerator < ListGenerator #:nodoc:
    include TopLevel
    include NestedGenerators
  end

  def ListGenerator.top_level(*args)
    TopLevelListGenerator.new(*args)
  end

end
