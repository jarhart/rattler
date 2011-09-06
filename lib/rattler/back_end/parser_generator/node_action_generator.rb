require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class NodeActionGenerator < ExprGenerator #:nodoc:

    def gen_basic(action, scope = ParserScope.empty)
      @g << action.bindable_code.bind(scope)
    end

    def gen_assert(action, scope = ParserScope.empty)
      expr { @g.suffix(' && true') { gen_basic action, scope } }
    end

    def gen_disallow(action, scope = ParserScope.empty)
      @g << '!'
      gen_basic action, scope
    end

    def gen_token(action, scope = ParserScope.empty)
      @g.suffix('.to_s') { gen_basic action, scope }
    end

    def gen_skip(action, scope = ParserScope.empty)
      expr { @g.suffix('; true') { gen_basic action, scope } }
    end

  end

  # @private
  class NestedNodeActionGenerator < NodeActionGenerator #:nodoc:
    include Nested
  end

  def NodeActionGenerator.nested(*args)
    NestedNodeActionGenerator.new(*args)
  end

  # @private
  class TopLevelNodeActionGenerator < NodeActionGenerator #:nodoc:
    include TopLevel
  end

  def NodeActionGenerator.top_level(*args)
    TopLevelNodeActionGenerator.new(*args)
  end

end
