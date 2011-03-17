require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class ListGenerator < ExprGenerator #:nodoc:
    include ListGenerating
    include NestedSubGenerating

    def gen_assert(optional, scope={})
      @g << 'true'
    end

    def gen_disallow(optional, scope={})
      @g << 'false'
    end

    def gen_skip(list, scope={})
      expr :block do
        gen_skipping list, scope
        @g.newline << 'true'
      end
    end

    protected

    def gen_result(captures)
      @g << captures
    end

  end

  # @private
  class NestedListGenerator < ListGenerator #:nodoc:
    include Nested
  end

  def ListGenerator.nested(*args)
    NestedListGenerator.new(*args)
  end

  # @private
  class TopLevelListGenerator < ListGenerator #:nodoc:
    include TopLevel
  end

  def ListGenerator.top_level(*args)
    TopLevelListGenerator.new(*args)
  end

end
