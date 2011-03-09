require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::Optimizer
include Rattler::Parsers

describe JoinPredicateOrNestedMatch do

  let(:skip) { Skip[Match[/a/]] }

  let(:assert) { Assert[Match[/b/]] }
  let(:disallow) { Disallow[Match[/b/]] }

  describe '#apply' do

    context 'given a choice with a skip of a match followed by a predicate' do

      let(:choice) { Choice[Apply[:a], skip, predicate] }

      context 'with an assert of a match' do

        let(:predicate) { assert }

        it 'reduces the match and assert into an equivalent skip of a match' do
          subject.apply(choice, :any).should ==
            Choice[Apply[:a], Skip[Match[/a|(?=b)/]]]
        end
      end

      context 'with a disallow of a match' do

        let(:predicate) { disallow }

        it 'reduces the match and disallow into an equivalent skip of a match' do
          subject.apply(choice, :any).should ==
            Choice[Apply[:a], Skip[Match[/a|(?!b)/]]]
        end
      end

      context 'with Eof' do

        let(:predicate) { Eof[] }

        it 'reduces the match and Eof into an equivalent skip of a match' do
          subject.apply(choice, :any).should ==
            Choice[Apply[:a], Skip[Match[/a|\z/]]]
        end
      end
    end

    context 'given a choice with a predicate followed by a skip of a match' do

      let(:choice) { Choice[Apply[:a], predicate, skip] }

      context 'with an assert of a match' do

        let(:predicate) { assert }

        it 'reduces the match and assert into an equivalent skip of a match' do
          subject.apply(choice, :any).should ==
            Choice[Apply[:a], Skip[Match[/(?=b)|a/]]]
        end
      end

      context 'with a disallow of a match' do

        let(:predicate) { disallow }

        it 'reduces the match and disallow into an equivalent skip of a match' do
          subject.apply(choice, :any).should ==
            Choice[Apply[:a], Skip[Match[/(?!b)|a/]]]
        end
      end

      context 'with Eof' do

        let(:predicate) { Eof[] }

        it 'reduces the match and Eof into an equivalent skip of a match' do
          subject.apply(choice, :any).should ==
            Choice[Apply[:a], Skip[Match[/\z|a/]]]
        end
      end
    end
  end

  describe '#applies_to?' do

    context 'given a choice with a skip of a match followed by a predicate' do

      let(:choice) { Choice[Apply[:a], skip, predicate] }

      context 'with an assert of a match' do

        let(:predicate) { assert }

        it 'returns true' do
          subject.applies_to?(choice, :any).should be_true
        end
      end

      context 'with a disallow of a match' do

        let(:predicate) { disallow }

        it 'returns true' do
          subject.applies_to?(choice, :any).should be_true
        end
      end

      context 'with Eof' do

        let(:predicate) { Eof[] }

        it 'returns true' do
          subject.applies_to?(choice, :any).should be_true
        end
      end
    end

    context 'given a choice with a predicate followed by a skip of a match' do

      let(:choice) { Choice[Apply[:a], predicate, skip] }

      context 'with an assert of a match' do

        let(:predicate) { assert }

        it 'returns true' do
          subject.applies_to?(choice, :any).should be_true
        end
      end

      context 'with a disallow of a match' do

        let(:predicate) { disallow }

        it 'returns true' do
          subject.applies_to?(choice, :any).should be_true
        end
      end

      context 'with Eof' do

        let(:predicate) { Eof[] }

        it 'returns true' do
          subject.applies_to?(choice, :any).should be_true
        end
      end
    end
  end

end
