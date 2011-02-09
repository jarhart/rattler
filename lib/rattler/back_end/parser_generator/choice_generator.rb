require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator
  
  # @private
  class ChoiceGenerator < ExprGenerator #:nodoc:
    include NestedGenerators
    
    def gen_basic_nested(choice)
      atomic_block { gen_basic_top_level choice }
    end
    
    def gen_basic_top_level(choice)
      @g.intersperse_nl(choice, ' ||') {|_| generate _ }
    end
    
    def gen_assert_nested(choice)
      atomic_expr { gen_assert_top_level choice }
    end
    
    def gen_assert_top_level(choice)
      gen_intermediate_assert choice
      @g << ' && true'
    end
    
    def gen_disallow(choice)
      @g << '!'
      gen_intermediate_assert choice
    end
    
    def gen_dispatch_action_nested(choice, target, method_name)
      atomic_block { gen_dispatch_action_top_level choice, target, method_name }
    end
    
    def gen_dispatch_action_top_level(choice, target, method_name)
      gen_action_code choice do |labeled|
        dispatch_action_result(target, method_name, :labeled => labeled)
      end
    end
    
    def gen_direct_action_nested(choice, action)
      atomic_block { gen_direct_action_top_level choice, action }
    end
    
    def gen_direct_action_top_level(choice, action)
      gen_action_code choice do |labeled|
        direct_action_result(action, :labeled => labeled)
      end
    end
    
    def gen_token_nested(choice)
      atomic_block { gen_token_top_level choice }
    end
    
    def gen_token_top_level(choice)
      @g.intersperse_nl(choice, ' ||') {|_| generate _, :gen_token }
    end
    
    def gen_skip_nested(choice)
      @g.surround('(', ')') { gen_skip_top_level choice }
    end
    
    def gen_skip_top_level(choice)
      gen_intermediate_skip choice
      @g << ' && true'
    end
    
    def gen_intermediate_assert(choice)
      atomic_block do
        @g.intersperse_nl(choice, ' ||') do |_|
          generate _, :gen_intermediate_assert
        end
      end
    end
    
    def gen_intermediate_skip(choice)
      atomic_block do
        @g.intersperse_nl(choice, ' ||') do |_|
          generate _, :gen_intermediate_skip
        end
      end
    end
    
    private
    
    def gen_action_code(choice)
      labeled = choice.any? {|_| _.labeled? } ? labeled_name : nil
      @g.block("(#{result_name} = begin", 'end)') do
        (@g << "#{labeled} = nil").newline if labeled
        @g.intersperse_nl(choice, ' ||') do |child|
          if child.labeled?
            atomic_expr do
              @g.surround("(#{result_name} = ", ')') { generate child }
              @g << " && (#{labeled} = {:#{child.label} => #{result_name}})"
              @g << " && #{result_name}"
            end
          else
            generate child
          end
        end
      end << ' && '
      @g << yield(labeled)
    end
    
    def labeled_name
      "l#{choice_level}"
    end
    
  end
  
  # @private
  class NestedChoiceGenerator < ChoiceGenerator #:nodoc:
    include Nested
  end
  
  def ChoiceGenerator.nested(*args)
    NestedChoiceGenerator.new(*args)
  end
  
  # @private
  class TopLevelChoiceGenerator < ChoiceGenerator #:nodoc:
    include TopLevel
  end
  
  def ChoiceGenerator.top_level(*args)
    TopLevelChoiceGenerator.new(*args)
  end
  
end
