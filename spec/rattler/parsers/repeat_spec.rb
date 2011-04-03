require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Repeat do
  include CombinatorParserSpecHelper

  let(:capturing_child) { Match[/\w/] }
  let(:skipping_child) { Skip[capturing_child] }
  let(:child) { capturing_child }

  describe '#parse' do

    context 'with a capturing parser' do

      let(:child) { Match[/\w/] }

      context 'with no upper bound' do

        subject { Repeat[child, 2, nil] }

        context 'when the parser matches enough times' do
          it 'matches returning the results in an array' do
            parsing('foo').should result_in(['f', 'o', 'o']).at(3)
          end
        end

        context 'when the parser matches too few times' do
          it 'fails' do
            parsing('f  ').should fail
          end
        end
      end

      context 'with an upper bound' do

        subject { Repeat[child, 2, 4] }

        context 'when the parser would match more times than the upper bound' do
          it 'stops matching at the upper bound' do
            parsing('abcde').should result_in(['a', 'b', 'c', 'd']).at(4)
          end
        end
      end
    end

    context 'with a non-capturing parser' do

      let(:child) { skipping_child }

      context 'with no upper bound' do

        subject { Repeat[child, 2, nil] }

        context 'when the parser matches enough times' do
          it 'matches returning true' do
            parsing('foo').should result_in(true).at(3)
          end
        end

        context 'when the parser matches too few times' do
          it 'fails' do
            parsing('f  ').should fail
          end
        end
      end

      context 'with an upper bound' do

        subject { Repeat[child, 2, 4] }

        context 'when the parser would match more times than the upper bound' do
          it 'stops matching at the upper bound' do
            parsing('abcde').should result_in(true).at(4)
          end
        end
      end
    end

  end

  describe '#capturing?' do

    context 'with a capturing parser' do

      subject { Repeat[capturing_child, 0, nil] }

      it 'is true' do
        subject.should be_capturing
      end
    end

    context 'with a non-capturing parser' do

      subject { Repeat[skipping_child, 0, nil] }

      it 'is false' do
        subject.should_not be_capturing
      end
    end

  end

  describe '#with_ws' do

    let(:ws) { Match[/\s*/] }
    subject { Repeat[child, 2, 4] }

    it 'applies #with_ws to the nested parser' do
      subject.with_ws(ws).
        should == Repeat[Sequence[Skip[ws], child], 2, 4]
    end
  end

  describe '#zero_or_more?' do

    context 'with zero-or-more bounds' do

      subject { Repeat[child, 0, nil] }

      it 'is true' do
        subject.should be_zero_or_more
      end
    end

    context 'with an upper bound' do

      subject { Repeat[child, 0, 10] }

      it 'is false' do
        subject.should_not be_zero_or_more
      end
    end

    context 'with non-zero lower bound' do

      subject { Repeat[child, 1, nil] }

      it 'is false' do
        subject.should_not be_zero_or_more
      end
    end
  end

  describe '#one_or_more?' do

    context 'with one-or-more bounds' do

      subject { Repeat[child, 1, nil] }

      it 'is true' do
        subject.should be_one_or_more
      end
    end

    context 'with an upper bound' do

      subject { Repeat[child, 1, 10] }

      it 'is false' do
        subject.should_not be_one_or_more
      end
    end

    context 'with non-one lower bound' do

      subject { Repeat[child, 0, nil] }

      it 'is false' do
        subject.should_not be_one_or_more
      end
    end
  end

  describe '#optional?' do

    context 'with optional bounds' do

      subject { Repeat[child, 0, 1] }

      it 'is true' do
        subject.should be_optional
      end
    end

    context 'with no upper bound' do

      subject { Repeat[child, 0, nil] }

      it 'is false' do
        subject.should_not be_optional
      end
    end

    context 'with non-one upper bound' do

      subject { Repeat[child, 0, 2] }

      it 'is false' do
        subject.should_not be_optional
      end
    end

    context 'with non-zero lower bound' do

      subject { Repeat[child, 1, 1] }

      it 'is false' do
        subject.should_not be_optional
      end
    end
  end
end
