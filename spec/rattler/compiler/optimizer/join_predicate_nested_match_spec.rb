require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Parsers

describe Rattler::Compiler::Optimizer::JoinPredicateNestedMatch do

  let(:skip) { Skip[Match[/a/]] }
  let(:token) { Token[Match[/a/]] }

  let(:assert) { Assert[Match[/b/]] }
  let(:disallow) { Disallow[Match[/b/]] }

  describe '#apply' do

    context 'given a sequence with a skip of a match followed by a predicate' do

      let(:sequence) { Sequence[Apply[:a], skip, predicate, Apply[:b]] }

      context 'with an assert of a match' do

        let(:predicate) { assert }

        it 'reduces the match and assert into an equivalent skipping match' do
          subject.apply(sequence, :any).should ==
            Sequence[Apply[:a], Skip[Match[/(?>a)(?=b)/]], Apply[:b]]
        end
      end

      context 'with a disallow of a match' do

        let(:predicate) { disallow }

        it 'reduces the match and disallow into an equivalent skipping match' do
          subject.apply(sequence, :any).should ==
            Sequence[Apply[:a], Skip[Match[/(?>a)(?!b)/]], Apply[:b]]
        end
      end

      context 'with Eof' do

        let(:predicate) { Eof[] }

        it 'reduces the match and Eof into an equivalent skipping match' do
          subject.apply(sequence, :any).should ==
            Sequence[Apply[:a], Skip[Match[/(?>a)\z/]], Apply[:b]]
        end
      end
    end

    context 'given a sequence with a predicate followed by a skip of a match' do

      let(:sequence) { Sequence[Apply[:a], predicate, skip, Apply[:b]] }

      context 'with an assert of a match' do

        let(:predicate) { assert }

        it 'reduces the match and assert into an equivalent skipping match' do
          subject.apply(sequence, :any).should ==
            Sequence[Apply[:a], Skip[Match[/(?=b)(?>a)/]], Apply[:b]]
        end
      end

      context 'with a disallow of a match' do

        let(:predicate) { disallow }

        it 'reduces the match and disallow into an equivalent skipping match' do
          subject.apply(sequence, :any).should ==
            Sequence[Apply[:a], Skip[Match[/(?!b)(?>a)/]], Apply[:b]]
        end
      end
    end
  end

  describe '#applies_to?' do

    context 'given a sequence with a skip of a match followed by a predicate' do

      let(:sequence) { Sequence[Apply[:a], skip, predicate, Apply[:b]] }

      context 'with an assert of a match' do

        let(:predicate) { assert }

        it 'returns true' do
          subject.applies_to?(sequence, :any).should be_true
        end
      end

      context 'with a disallow of a match' do

        let(:predicate) { disallow }

        it 'returns true' do
          subject.applies_to?(sequence, :any).should be_true
        end
      end

      context 'with Eof' do

        let(:predicate) { Eof[] }

        it 'returns true' do
          subject.applies_to?(sequence, :any).should be_true
        end
      end

      context 'with an assert of something else' do

        let(:predicate) { Assert[Apply[:a]]}

        it 'returns false' do
          subject.applies_to?(sequence, :any).should be_false
        end
      end

      context 'with a disallow of something else' do

        let(:predicate) { Disallow[Apply[:a]]}

        it 'returns false' do
          subject.applies_to?(sequence, :any).should be_false
        end
      end
    end


    context 'given a sequence with a predicate followed by a skip of match' do

      let(:sequence) { Sequence[Apply[:a], predicate, skip, Apply[:b]] }

      context 'with an assert of a match' do

        let(:predicate) { assert }

        it 'returns true' do
          subject.applies_to?(sequence, :any).should be_true
        end
      end

      context 'with a disallow of a match' do

        let(:predicate) { disallow }

        it 'returns true' do
          subject.applies_to?(sequence, :any).should be_true
        end
      end

      context 'with an assert of something else' do

        let(:predicate) { Assert[Apply[:a]]}

        it 'returns false' do
          subject.applies_to?(sequence, :any).should be_false
        end
      end

      context 'with a disallow of something else' do

        let(:predicate) { Disallow[Apply[:a]]}

        it 'returns false' do
          subject.applies_to?(sequence, :any).should be_false
        end
      end
    end

    context 'given a sequence with a match and a predicate not adjacent' do

      let(:sequence) { Sequence[Apply[:a], skip, Apply[:b], assert] }

      it 'returns false' do
        subject.applies_to?(sequence, :any).should be_false
      end
    end
  end

end
