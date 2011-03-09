require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include Rattler::Parsers

describe Rattler::Grammar::GrammarParser do
  include Rattler::Util::ParserSpecHelper

  let :posix_names do
    %w{alnum alpha blank cntrl digit graph lower print punct space upper xdigit}
  end

  describe '#match(:expression)' do

    context 'given a perl-style regex' do

      context 'delimited with "/"s' do
        it 'parses as a regex match' do
          matching(' /\\d+(?:\\.\\d+)?/ ').as(:expression).
            should result_in(Match[/\d+(?:\.\d+)?/]).at(16)
        end
      end
    end

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

    it 'parses dispatch-action-attributed expressions' do
      matching(' expr <Expr> ').as(:expression).
        should result_in(DispatchAction[Apply[:expr], {:target => 'Expr', :method => 'parsed'}]).
        at(12)
    end

    it 'parses direct-action-attributed expressions' do
      matching(' digits {|_| _.to_i} ').as(:expression).
        should result_in(DirectAction[Apply[:digits], '|_| _.to_i']).at(20)
    end

    it 'parses sequence expressions' do
      matching(' name "=" value ').as(:expression).
        should result_in(Sequence[Apply[:name], Match[%r{=}], Apply[:value]]).at(15)
    end

    it 'parses attributed sequence expressions' do
      matching(' name "=" value <Assign>').as(:expression).
        should result_in(DispatchAction[
                          Sequence[Apply[:name], Match[%r{=}], Apply[:value]],
                          {:target => 'Assign', :method => 'parsed'}]).
                at(24)
    end

    it 'parses choice expressions' do
      matching(' string | number ').as(:expression).
        should result_in(Choice[Apply[:string], Apply[:number]]).at(16)
    end

    it 'skips normal whitespace' do
      matching("  \n\t foo").as(:expression).should result_in(Apply[:foo]).at(8)
    end

    it 'skips comments' do
      matching("\n# a comment\n\t foo").as(:expression).
        should result_in(Apply[:foo]).at(18)
    end
  end

  describe '#match(:attributed)' do
    it 'recognizes dispatch-action-attributed expressions' do
      matching(' expr <Expr> ').as(:attributed).
        should result_in(DispatchAction[Apply[:expr], {:target => 'Expr', :method => 'parsed'}]).
        at(12)
    end

    it 'recognizes direct-action-attributed expressions' do
      matching(' digits {|_| _.to_i} ').as(:attributed).
        should result_in(DirectAction[Apply[:digits], '|_| _.to_i']).at(20)
    end
  end

  describe '#match(:term)' do
    it 'recognizes optional terms' do
      matching(' expr? ').as(:term).should result_in(Optional[Apply[:expr]]).at(6)
    end

    it 'recognizes zero-or-more terms' do
      matching(' expr* ').as(:term).should result_in(ZeroOrMore[Apply[:expr]]).at(6)
    end

    it 'recognizes one-or-more terms' do
      matching(' expr+ ').as(:term).should result_in(OneOrMore[Apply[:expr]]).at(6)
    end

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
