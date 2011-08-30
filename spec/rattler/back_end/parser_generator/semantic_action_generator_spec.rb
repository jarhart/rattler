require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::ParserGenerator
include Rattler::Parsers

describe SemanticActionGenerator do

  include ParserGeneratorSpecHelper

  let(:scope) { ParserScope.new(bindings, captures) }
  let(:bindings) { {} }
  let(:captures) { [] }

  describe '#gen_basic' do

    context 'given an action with no parameters' do

      let(:action) { SemanticAction['@foo * 3'] }

      context 'when nested' do
        it 'generates nested semantic action code' do
          nested_code {|g| g.gen_basic action }.
          should == '(@foo * 3)'
        end
      end

      context 'when top-level' do
        it 'generates top level semantic action code' do
          top_level_code {|g| g.gen_basic action }.
          should == '@foo * 3'
        end
      end
    end

    context 'given an action with parameters' do

      let(:action) { SemanticAction['|a,b| a * b'] }
      let(:captures) { ['2', '5'] }

      context 'when nested' do
        it 'generates nested semantic action code using captures' do
          nested_code {|g| g.gen_basic action, scope }.
          should == '(2 * 5)'
        end
      end

      context 'when top-level' do
        it 'generates top level semantic action code using captures' do
          top_level_code {|g| g.gen_basic action, scope }.
          should == '2 * 5'
        end
      end
    end

    context 'given an action using "_"' do

      context 'given a single capture' do

        let (:action) { SemanticAction['_ * 2'] }
        let (:captures) { ['3'] }

        context 'when nested' do
          it 'generates nested semantic action code using the capture' do
            nested_code {|g| g.gen_basic action, scope }.
            should == ('(3 * 2)')
          end
        end

        context 'when top-level' do
          it 'generates top level semantic action code using the capture' do
            top_level_code {|g| g.gen_basic action, scope }.
            should == ('3 * 2')
          end
        end
      end

      context 'given multiple captures' do

        let (:action) { SemanticAction['_.join'] }
        let (:captures) { ['3', '2'] }

        context 'when nested' do
          it 'generates nested semantic action code using the array of captures' do
            nested_code {|g| g.gen_basic action, scope }.
            should == ('([3, 2].join)')
          end
        end

        context 'when top-level' do
          it 'generates top level semantic action code using the array of captures' do
            top_level_code {|g| g.gen_basic action, scope }.
            should == ('[3, 2].join')
          end
        end
      end
    end

    context 'given an action using labels' do

      let(:action) { SemanticAction['left * right'] }
      let(:bindings) { {:left => '3', :right => '2'} }

      context 'when nested' do
        it 'generates nested semantic action code using bindings' do
          nested_code {|g| g.gen_basic action, scope }.
          should == '(3 * 2)'
        end
      end

      context 'when top-level' do
        it 'generates top level semantic action code using bindings' do
          top_level_code {|g| g.gen_basic action, scope }.
          should == '3 * 2'
        end
      end
    end
  end

  describe '#gen_assert' do

    context 'given an action with no parameters' do

      let(:action) { SemanticAction['@foo == 3'] }

      context 'when nested' do
        it 'generates nested semantic assert code' do
          nested_code {|g| g.gen_assert action }.
          should == '((@foo == 3) && true)'
        end
      end

      context 'when top-level' do
        it 'generates top level semantic assert code' do
          top_level_code {|g| g.gen_assert action }.
          should == '(@foo == 3) && true'
        end
      end
    end

    context 'given an action with parameters' do

      let(:action) { SemanticAction['|a,b| a == b'] }
      let(:captures) { ['2', '1'] }

      context 'when nested' do
        it 'generates nested semantic assert code using captures' do
          nested_code {|g| g.gen_assert action, scope }.
          should == '((2 == 1) && true)'
        end
      end

      context 'when top-level' do
        it 'generates top level semantic assert code using captures' do
          top_level_code {|g| g.gen_assert action, scope }.
          should == '(2 == 1) && true'
        end
      end
    end

    context 'given an action using labels' do

      let(:action) { SemanticAction['left < right'] }
      let(:bindings) { {:left => '2', :right => '3'} }

      context 'when nested' do
        it 'generates nested semantic assert code using bindings' do
          nested_code {|g| g.gen_assert action, scope }.
          should == '((2 < 3) && true)'
        end
      end

      context 'when top-level' do
        it 'generates top level semantic assert code using bindings' do
          top_level_code {|g| g.gen_assert action, scope }.
          should == '(2 < 3) && true'
        end
      end
    end
  end

  describe '#gen_disallow' do

    context 'given an action with no parameters' do

      let(:action) { SemanticAction['@foo == 3'] }

      context 'when nested' do
        it 'generates semantic disallow code' do
          nested_code {|g| g.gen_disallow action }.
          should == '!(@foo == 3)'
        end
      end

      context 'when top-level' do
        it 'generates semantic disallow code' do
          top_level_code {|g| g.gen_disallow action }.
          should == '!(@foo == 3)'
        end
      end
    end

    context 'given an action with parameters' do

      let(:action) { SemanticAction['|a,b| a == b'] }
      let(:captures) { ['2', '1'] }

      context 'when nested' do
        it 'generates semantic disallow code using captures' do
          nested_code {|g| g.gen_disallow action, scope }.
          should == '!(2 == 1)'
        end
      end

      context 'when top-level' do
        it 'generates semantic disallow code using captures' do
          top_level_code {|g| g.gen_disallow action, scope }.
          should == '!(2 == 1)'
        end
      end
    end

    context 'given an action using labels' do

      let(:action) { SemanticAction['left < right'] }
      let(:bindings) { {:left => '2', :right => '3'} }

      context 'when nested' do
        it 'generates semantic disallow code using bindings' do
          nested_code {|g| g.gen_disallow action, scope }.
          should == '!(2 < 3)'
        end
      end

      context 'when top-level' do
        it 'generates semantic disallow code using bindings' do
          top_level_code {|g| g.gen_disallow action, scope }.
          should == '!(2 < 3)'
        end
      end
    end
  end

  describe '#gen_token' do

    context 'given an action with no parameters' do

      let(:action) { SemanticAction['@foo * 2'] }

      context 'when nested' do
        it 'generates semantic token code' do
          nested_code {|g| g.gen_token action }.
          should == '(@foo * 2).to_s'
        end
      end

      context 'when top-level' do
        it 'generates semantic token code' do
          top_level_code {|g| g.gen_token action }.
          should == '(@foo * 2).to_s'
        end
      end
    end

    context 'given an action with parameters' do

      let(:action) { SemanticAction['|a, b| a + b'] }
      let(:captures) { ['1', '3'] }

      context 'when nested' do
        it 'generates semantic token code using captures' do
          nested_code {|g| g.gen_token action, scope }.
          should == '(1 + 3).to_s'
        end
      end

      context 'when top-level' do
        it 'generates semantic token code using captures' do
          top_level_code {|g| g.gen_token action, scope }.
          should == '(1 + 3).to_s'
        end
      end
    end

    context 'given an action using labels' do

      let(:action) { SemanticAction['left * right'] }
      let(:bindings) { {:left => '4', :right => '3'} }

      context 'when nested' do
        it 'generates semantic token code using bindings' do
          nested_code {|g| g.gen_token action, scope }.
          should == '(4 * 3).to_s'
        end
      end

      context 'when top-level' do
        it 'generates semantic token code using bindings' do
          top_level_code {|g| g.gen_token action, scope }.
          should == '(4 * 3).to_s'
        end
      end
    end
  end

  describe '#gen_skip' do

    context 'given an action with no parameters' do

      let(:action) { SemanticAction['@foo = 2'] }

      context 'when nested' do
        it 'generates nested semantic side-effect code' do
          nested_code {|g| g.gen_skip action }.
          should == '(@foo = 2; true)'
        end
      end

      context 'when top-level' do
        it 'generates top level semantic side-effect code' do
          top_level_code {|g| g.gen_skip action }.
          should == '@foo = 2; true'
        end
      end
    end

    context 'given an action with parameters' do

      let(:action) { SemanticAction['|a, b| @foo = a * b'] }
      let(:captures) { ['2', '4'] }

      context 'when nested' do
        it 'generates nested semantic side-effect code using captures' do
          nested_code {|g| g.gen_skip action, scope }.
          should == '(@foo = 2 * 4; true)'
        end
      end

      context 'when top-level' do
        it 'generates top level semantic side-effect code using captures' do
          top_level_code {|g| g.gen_skip action, scope }.
          should == '@foo = 2 * 4; true'
        end
      end
    end

    context 'given an action using labels' do

      let(:action) { SemanticAction['@foo = left * right'] }
      let(:bindings) { {:left => '2', :right => '1'} }

      context 'when nested' do
        it 'generates nested semantic side-effect code using bindings' do
          nested_code {|g| g.gen_skip action, scope }.
          should == '(@foo = 2 * 1; true)'
        end
      end

      context 'when top-level' do
        it 'generates top level semantic side-effect code using bindings' do
          top_level_code {|g| g.gen_skip action, scope }.
          should == '@foo = 2 * 1; true'
        end
      end
    end
  end

  describe '#gen_intermediate_assert' do

    context 'given an action with no parameters' do

      let(:action) { SemanticAction['@foo == 3'] }

      it 'generates intermediate semantic assert code' do
        nested_code {|g| g.gen_intermediate_assert action }.
        should == '(@foo == 3)'
      end
    end

    context 'given an action with parameters' do

      let(:action) { SemanticAction['|a,b| a == b'] }
      let(:captures) { ['2', '1'] }

      it 'generates intermediate semantic assert code using captures' do
        nested_code {|g| g.gen_intermediate_assert action, scope }.
        should == '(2 == 1)'
      end
    end

    context 'given an action using labels' do

      let(:action) { SemanticAction['left < right'] }
      let(:bindings) { {:left => '2', :right => '3'} }

      it 'generates intermediate assert code using bindings' do
        nested_code {|g| g.gen_intermediate_assert action, scope }.
        should == '(2 < 3)'
      end
    end
  end

  describe '#gen_intermediate_skip' do

    context 'given an action with no parameters' do

      let(:action) { SemanticAction['@foo = 2'] }

      it 'generates intermediate semantic side-effect code' do
        nested_code {|g| g.gen_intermediate_skip action }.
        should == '(@foo = 2)'
      end
    end

    context 'given an action with parameters' do

      let(:action) { SemanticAction['|a, b| @foo = a * b'] }
      let(:captures) { ['2', '4'] }

      it 'generates intermediate semantic side-effect code using captures' do
        nested_code {|g| g.gen_intermediate_skip action, scope }.
        should == '(@foo = 2 * 4)'
      end
    end

    context 'given an action using labels' do

      let(:action) { SemanticAction['@foo = left * right'] }
      let(:bindings) { {:left => '2', :right => '1'} }

      it 'generates intermediate semantic side-effect code using bindings' do
        nested_code {|g| g.gen_intermediate_skip action, scope }.
        should == '(@foo = 2 * 1)'
      end
    end
  end

end
