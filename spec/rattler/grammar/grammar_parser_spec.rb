require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include Rattler::Parsers

describe Rattler::Grammar::GrammarParser do
  include Rattler::Util::ParserSpecHelper

  let :posix_names do
    %w{alnum alpha blank cntrl digit graph lower print punct space upper xdigit}
  end

  describe '#match(:expression)' do

    context 'given a string literal' do

      context 'delimited by double quotes' do
        it 'parses as a regex match' do
          matching(%{ "a string" }).as(:expression).
            should result_in(Match[/a\ string/]).at(11)
        end
      end

      context 'delimited by single quotes' do
        it 'parses as a regex match' do
          matching(%{ 'a string' }).as(:expression).
            should result_in(Match[/a\ string/]).at(11)
        end
      end

      context 'using "general delimited text" syntax' do

        context 'with "(" and ")"' do
          it 'parses as a regex match' do
            matching(' %(a string) ').as(:expression).
              should result_in(Match[/a\ string/]).at(12)
          end
        end

        context 'with "{" and "}"' do
          it 'parses as a regex match' do
            matching(' %{a string} ').as(:expression).
              should result_in(Match[/a\ string/]).at(12)
          end
        end

        context 'with "[" and "]"' do
          it 'parses as a regex match' do
            matching(' %[a string] ').as(:expression).
              should result_in(Match[/a\ string/]).at(12)
          end
        end

        context 'with "<" and ">"' do
          it 'parses as a regex match' do
            matching(' %<a string> ').as(:expression).
              should result_in(Match[/a\ string/]).at(12)
          end
        end

        context 'with arbitrary delimiters' do
          it 'parses as a regex match' do
            matching(' %!a string! ').as(:expression).
              should result_in(Match[/a\ string/]).at(12)
          end
        end
      end

      context 'delimited by backquotes' do
        it 'parses as a word literal' do
          matching(%{ `where` }).as(:expression).should result_in(
            Token[Sequence[Match[/where/], Disallow[Match[/[[:alnum:]_]/]]]]
          ).at(8)
        end
      end

      context 'with special characters' do
        it 'escapes the special characters' do
          matching(%{ "[...]" }).as(:expression).
            should result_in(Match[/\[\.\.\.\]/]).at(8)
        end
      end
    end

    context 'given a character class expression' do

      context 'with a simple list of characters' do
        it 'parses as a regex match' do
          matching(' [abc123] ').as(:expression).
            should result_in(Match[/[abc123]/]).at(9)
        end
      end

      context 'with octal codes' do
        it 'parses as a regex match' do
          matching(' [\010\012\015] ').as(:expression).
            should result_in(Match[/[\010\012\015]/]).at(15)
        end
      end

      context 'with hex codes' do
        it 'parses as a regex match' do
          matching(' [\x08\x0A\x0D] ').as(:expression).
            should result_in(Match[/[\x08\x0A\x0D]/]).at(15)
        end
      end

      context 'with a range of characters' do
        it 'parses as a regex match' do
          matching(' [A-F] ').as(:expression).
            should result_in(Match[/[A-F]/]).at(6)
        end
      end

      context 'with a range of octal codes' do
        it 'parses as a regex match' do
          matching(' [\000-\177] ').as(:expression).
            should result_in(Match[/[\000-\177]/]).at(12)
        end
      end

      context 'with a range of hex codes' do
        it 'parses as a regex match' do
          matching(' [\x00-\x7F] ').as(:expression).
            should result_in(Match[/[\x00-\x7F]/]).at(12)
        end
      end
    end

    context 'given a "."' do
      it 'parses as Match[/./]' do
        matching(' . ').as(:expression).should result_in(Match[/./]).at(2)
      end
    end

    context 'given a lower-case word' do
      it 'parses as an Apply' do
        matching(' fooBar ').as(:expression).should result_in(Apply[:fooBar]).at(7)
      end
    end

    context 'given a upper-case word' do
      it 'parses it as an Apply' do
        matching(' FooBar ').as(:expression).should result_in(Apply[:FooBar]).at(7)
      end
    end

    context 'given the EOF keyword' do
      it 'parses as Eof[]' do
        matching(' EOF ').as(:expression).should result_in(Eof[]).at(4)
      end
    end

    context 'given the E symbol' do
      it 'parses as ESymbol[]' do
        matching(' E ').as(:expression).should result_in(ESymbol[]).at(2)
      end
    end

    context 'given an upper-case POSIX class name' do
      it 'parses as a Match of a POSIX character class' do
        for name in posix_names
          matching(" #{name.upcase} ").as(:expression).
            should result_in(Match[Regexp.new("[[:#{name}:]]")]).
            at(name.length + 1)
        end
      end
    end

    context 'given the non-POSIX WORD class name' do
      it 'parses as syntactic sugar for [[:alnum:]_]' do
        matching(' WORD ').as(:expression).
          should result_in(Match[/[[:alnum:]_]/]).at(5)
      end
    end

    context 'given a semantic result' do
      it 'parses as a SemanticAction' do
        matching(' ^{ 42 } ').as(:expression).
          should result_in(SemanticAction['42']).at(8)
      end
    end

    context 'given a positive semantic predicate' do
      it 'parses as an Assert of a SemanticAction' do
        matching(' &{ 42 } ').as(:expression).
          should result_in(Assert[SemanticAction['42']]).at(8)
      end
    end

    context 'given a negative semantic predicate' do
      it 'parses as a Disallow of a SemanticAction' do
        matching(' !{ 42 } ').as(:expression).
          should result_in(Disallow[SemanticAction['42']]).at(8)
      end
    end

    context 'given a semantic side-effect predicate' do
      it 'parses as a Skip of a SemanticAction' do
        matching(' ~{ 42 } ').as(:expression).
          should result_in(Skip[SemanticAction['42']]).at(8)
      end
    end

    context 'given an optional expression' do
      it 'parses as a Repeat with optional bounds' do
        matching(' expr? ').as(:expression).
          should result_in(Repeat[Apply[:expr], 0, 1]).at(6)
      end
    end

    context 'given a zero-or-more expression' do
      it 'parses as a Repeat with zero-or-more bounds' do
        matching(' expr* ').as(:expression).
          should result_in(Repeat[Apply[:expr], 0, nil]).at(6)
      end
    end

    context 'given a one-or-more expression' do
      it 'parses as a Repeat with one-or-more bounds' do
        matching(' expr+ ').as(:expression).
          should result_in(Repeat[Apply[:expr], 1, nil]).at(6)
      end
    end

    context 'given a generalized repeat expression' do
      context 'with a single count' do
        it 'parses as a Repeat with the count as both lower and upper bounds' do
          matching(' expr 2 ').as(:expression).
            should result_in(Repeat[Apply[:expr], 2, 2]).at(7)
        end
      end

      context 'with a range' do
        it 'parses as a Repeat with lower and upper bounds' do
          matching(' expr 2..4 ').as(:expression).
            should result_in(Repeat[Apply[:expr], 2, 4]).at(10)
        end

        context 'with no upper bound' do
          it 'parses as a Repeat with no upper bound' do
            matching(' expr 2.. ').as(:expression).
              should result_in(Repeat[Apply[:expr], 2, nil]).at(9)
          end
        end
      end
    end

    context 'given a zero-or-more list expression' do
      it 'parses as a ListParser with zero-or-more bounds' do
        matching(' expr *, ";" ').as(:expression).
          should result_in(ListParser[Apply[:expr], Match[/;/], 0, nil]).at(12)
      end
    end

    context 'given a one-or-more list expression' do
      it 'parses as a ListParser with one-or-more bounds' do
        matching(' expr +, ";" ').as(:expression).
          should result_in(ListParser[Apply[:expr], Match[/;/], 1, nil]).at(12)
      end
    end

    context 'given a generalized list expression' do
      context 'with a single count' do
        it 'parses as a ListParser with the count as both lower and upper bounds' do
          matching(' expr 2, ";" ').as(:expression).
            should result_in(ListParser[Apply[:expr], Match[/;/], 2, 2]).at(12)
        end
      end

      context 'with a range' do
        it 'parses as a ListParser with lower and upper bounds' do
          matching(' expr 2..4, ";" ').as(:expression).
            should result_in(ListParser[Apply[:expr], Match[/;/], 2, 4]).at(15)
        end

        context 'with no upper bound' do
          it 'parses as a Repeat with no upper bound' do
            matching(' expr 2.., ";" ').as(:expression).
              should result_in(ListParser[Apply[:expr], Match[/;/], 2, nil]).at(14)
          end
        end
      end
    end

    context 'given a sequence expression' do
      it 'parses as a Sequence' do
        matching(' name "=" value ').as(:expression).
          should result_in(Sequence[Apply[:name], Match[%r{=}], Apply[:value]]).at(15)
      end

      context 'with a nested sequence expression' do
        it 'parses as a nested Sequence' do
          matching(' a (b c) d ').as(:expression).
            should result_in(Sequence[
              Apply[:a],
              Sequence[Apply[:b], Apply[:c]],
              Apply[:d]
            ]).at(10)
        end
      end

      context 'with a semantic result' do
        it 'parses as a Sequence with a SemanticAction' do
          matching(' a b ^{|a,b| a + b } ').as(:expression).
            should result_in(Sequence[
              Apply[:a],
              Apply[:b],
              SemanticAction['|a,b| a + b']
            ]).at(20)
        end
      end

      context 'with a semantic side-effect' do
        it 'parses as a Sequence with a Skip of a SemanticAction' do
          matching(' a b ~{|a,b| a + b } ').as(:expression).
            should result_in(Sequence[
              Apply[:a],
              Apply[:b],
              Skip[SemanticAction['|a,b| a + b']]
            ]).at(20)
        end
      end
    end

    context 'given an attributed expression' do

      context 'with a single term and a semantic action' do
        it 'parses as an AttributedSequence' do
          matching(' digits {|_| _.to_i} ').as(:expression).
            should result_in(AttributedSequence[
              Apply[:digits], SemanticAction['|_| _.to_i']
            ]).at(20)
        end
      end

      context 'with a single term and a node action' do

        context 'with just a class name' do
          it 'parses as an AttributedSequence' do
            matching(' expr <Expr> ').as(:expression).
              should result_in(AttributedSequence[
                Apply[:expr], NodeAction['Expr']
              ]).at(12)
          end
        end

        context 'with a class name and a method name' do
          it 'parses as an AttributedSequence with the method attribute' do
            matching(' expr <Expr.create> ').as(:expression).
              should result_in(AttributedSequence[
                Apply[:expr], NodeAction['Expr', {:method => 'create'}]
              ]).at(19)
          end
        end

        context 'with a class name and a node name' do
          it 'parses as an AttributedSequence with the node name attribute' do
            matching(' expr <Expr "EXPR"> ').as(:expression).
              should result_in(AttributedSequence[
                Apply[:expr],
                NodeAction['Expr', {:node_attrs => {:name => 'EXPR'}}]
              ]).at(19)
          end
        end

        context 'with class, method and node names' do
          it 'parses as an AttributedSequence with the method and node name attributes' do
            matching(' expr <Expr.create "EXPR"> ').as(:expression).
              should result_in(AttributedSequence[
                Apply[:expr],
                NodeAction['Expr', { :method => 'create',
                                     :node_attrs => {:name => 'EXPR'} }]
              ]).at(26)
          end
        end

        context 'with no names' do
          it 'parses as an AttributedSequence with a default NodeAction' do
            matching(' expr <> ').as(:expression).
              should result_in(AttributedSequence[
                Apply[:expr], NodeAction['Rattler::Runtime::ParseNode']
              ]).at(8)
          end
        end

        context 'with just a node name' do
          it 'parses as an AttributedSequence with a node name attribute' do
            matching(' expr <"EXPR"> ').as(:expression).
              should result_in(AttributedSequence[
                Apply[:expr],
                NodeAction['Rattler::Runtime::ParseNode',
                            {:node_attrs => {:name => 'EXPR'}}]
              ]).at(14)
          end
        end
      end

      context 'with multiple terms and a semantic action' do
        it 'parses as an AttributedSequence' do
          matching(' name "=" value {|_| _.size }').as(:expression).
            should result_in(AttributedSequence[
              Apply[:name],
              Match[%r{=}],
              Apply[:value],
              SemanticAction['|_| _.size']
            ]).at(29)
        end
      end

      context 'with multiple terms and a node action' do
        it 'parses as an AttributedSequence' do
          matching(' name "=" value <Assign>').as(:expression).
            should result_in(AttributedSequence[
              Apply[:name],
              Match[%r{=}],
              Apply[:value],
              NodeAction['Assign']
            ]).at(24)
        end
      end
    end

    context 'given a lone semantic action' do
      it 'parses as a SemanticAction' do
        matching(' { 42 } ').as(:expression).
          should result_in(SemanticAction['42']).at(7)
      end
    end

    context 'given a lone node action' do
      it 'parses as a NodeAction' do
        matching(' <Foo> ').as(:expression).
          should result_in(NodeAction['Foo']).at(6)
      end
    end

    context 'given a multiple-semantic-attirbuted expression' do
      it 'parses as nested AttributedSequences' do
        matching(' digits {|_| _.to_i } {|_| _ * 2 } ').as(:expression).
          should result_in(AttributedSequence[
            AttributedSequence[Apply[:digits], SemanticAction['|_| _.to_i']],
            SemanticAction['|_| _ * 2']
          ]).at(34)
      end
    end

    context 'given a multiple-node-attirbuted expression' do
      it 'parses as nested AttributedSequences' do
        matching(' digits <Int> <Expr> ').as(:expression).
          should result_in(AttributedSequence[
            AttributedSequence[Apply[:digits], NodeAction['Int']],
            NodeAction['Expr']
          ]).at(20)
      end
    end

    context 'given consecutive semantic-attributed expressions' do
      it 'parses as nested AttributedSequences' do
        matching(' digits {|_| _.to_i } foo {|_| _ * 2 } ').as(:expression).
          should result_in(AttributedSequence[
            AttributedSequence[
              Apply[:digits], SemanticAction['|_| _.to_i']
            ],
            Apply[:foo],
            SemanticAction['|_| _ * 2']
          ]).at(38)
      end
    end

    context 'given consecutive semantic-attributed expressions' do
      it 'parses as nested AttributedSequences' do
        matching(' digits <Int> foo <Foo> ').as(:expression).
          should result_in(AttributedSequence[
            AttributedSequence[
              Apply[:digits], NodeAction['Int']
            ],
            Apply[:foo],
            NodeAction['Foo']
          ]).at(23)
      end
    end

    context 'given an ordered choice expression' do
      it 'parses as a Choice' do
        matching(' string / number ').as(:expression).
          should result_in(Choice[Apply[:string], Apply[:number]]).at(16)
      end
    end

    context 'given an ordered choice with sequences' do
      it 'parses as a Choice of Sequences' do
        matching(' foo bar / boo far ').as(:expression).
          should result_in(Choice[
            Sequence[Apply[:foo], Apply[:bar]],
            Sequence[Apply[:boo], Apply[:far]]
          ]).at(18)
      end
    end

    it 'skips normal whitespace' do
      matching("  \n\t foo").as(:expression).should result_in(Apply[:foo]).at(8)
    end

    it 'skips comments' do
      matching("\n# a comment\n\t foo").as(:expression).
        should result_in(Apply[:foo]).at(18)
    end
  end

  describe '#match(:term)' do
    it 'recognizes assert terms' do
      matching(' &expr ').as(:term).should result_in(Assert[Apply[:expr]]).at(6)
    end

    it 'recognizes disallow terms' do
      matching(' !expr ').as(:term).should result_in(Disallow[Apply[:expr]]).at(6)
    end

    it 'recognizes skip terms' do
      matching(' ~expr ').as(:term).should result_in(Skip[Apply[:expr]]).at(6)
    end

    it 'recognizes token terms' do
      matching(' @expr ').as(:term).should result_in(Token[Apply[:expr]]).at(6)
    end

    it 'recognizes labeled terms' do
      matching(' val:expr ').as(:term).should result_in(Label[:val, Apply[:expr]]).at(9)
    end

    it 'recognizes fail expressions' do
      matching(' fail("bad!") ').as(:term).
        should result_in(Fail[:expr, 'bad!']).at(13)
      matching(' fail "bad!" ').as(:term).
        should result_in(Fail[:expr, 'bad!']).at(12)
    end

    it 'recognizes fail_rule expressions' do
      matching(' fail_rule("bad!") ').as(:term).
        should result_in(Fail[:rule, 'bad!']).at(18)
      matching(' fail_rule "bad!" ').as(:term).
        should result_in(Fail[:rule, 'bad!']).at(17)
    end

    it 'recognizes fail_parse expressions' do
      matching(' fail_parse("bad!") ').as(:term).
        should result_in(Fail[:parse, 'bad!']).at(19)
      matching(' fail_parse "bad!" ').as(:term).
        should result_in(Fail[:parse, 'bad!']).at(18)
    end
  end

end
