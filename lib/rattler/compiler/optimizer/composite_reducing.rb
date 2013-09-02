require 'rattler/compiler/optimizer'

module Rattler::Compiler::Optimizer
  # @private
  module CompositeReducing #:nodoc:

    protected

    def finish_reduce(parser, new_children)
      if new_children.size == 1
        new_children[0]
      else
        parser.with_children(new_children)
      end
    end

  end
end
